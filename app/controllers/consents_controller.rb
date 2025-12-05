class ConsentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_sprint
  before_action :set_learner, except: [:navigator, :manage_activities, :create_activity, :update_activity, :destroy_activity]
  before_action :ensure_lc_or_admin, only: [:navigator, :manage_activities, :create_activity, :update_activity, :destroy_activity]

  def build_week
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    # Handle date parameter for navigation
    begin
      @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      @current_date = Date.today
    end
    @current_date ||= Date.today

    # First, try to find a build week that contains the current date
    @nearest_build_week = Week.where("start_date <= ? AND end_date >= ? AND name ILIKE ?", @current_date, @current_date, "%Build%").first

    # If no build week found for current date, find the nearest one (past or future)
    if @nearest_build_week.nil?
      # Try to find the nearest past build week
      past_build_week = Week.where("end_date < ? AND name ILIKE ?", @current_date, "%Build%").order(end_date: :desc).first
      # Try to find the nearest future build week
      future_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_date, "%Build%").order(:start_date).first

      # Choose the closest one
      if past_build_week && future_build_week
        # If both exist, choose the one closest to current_date
        past_diff = (@current_date - past_build_week.end_date).abs
        future_diff = (future_build_week.start_date - @current_date).abs
        @nearest_build_week = past_diff < future_diff ? past_build_week : future_build_week
      elsif past_build_week
        @nearest_build_week = past_build_week
      elsif future_build_week
        @nearest_build_week = future_build_week
      else
        # If no build weeks exist at all, try to find any build week
        @nearest_build_week = Week.where("name ILIKE ?", "%Build%").order(:start_date).first
      end
    end

    # Find previous and next build weeks for navigation
    if @nearest_build_week
      @prev_build_week = Week.where("start_date < ? AND name ILIKE ?", @nearest_build_week.start_date, "%Build%").order(start_date: :desc).first
      @next_build_week = Week.where("start_date > ? AND name ILIKE ?", @nearest_build_week.end_date, "%Build%").order(:start_date).first
    else
      @prev_build_week = nil
      @next_build_week = nil
    end

    bw_existing = Consent.find_by(user_id: @learner.id, week_id: @nearest_build_week&.id)

    if bw_existing
      @bw_consent = bw_existing
    else
      # Get the most recent consent for this user to pre-populate fields
      last_consent = Consent.where(user_id: @learner.id).order(created_at: :desc).first

      Rails.logger.debug "Found last consent: #{last_consent.present?}" if Rails.env.development?
      Rails.logger.debug "Last consent ID: #{last_consent&.id}, emergency_contact_name: #{last_consent&.emergency_contact_name}" if Rails.env.development?

      # Create new consent with week dates
      @bw_consent = Consent.new(
        user_id: @learner.id,
        week_id: @nearest_build_week&.id,
        hub: @learner.main_hub&.name,
        start_date: @nearest_build_week&.start_date,
        end_date: @nearest_build_week&.end_date
      )

      # Populate common fields from the last consent
      if last_consent
        Rails.logger.debug "Populating fields from consent ID: #{last_consent.id}" if Rails.env.development?
        populate_common_fields(@bw_consent, last_consent)
        Rails.logger.debug "After populate - emergency contact name: #{@bw_consent.emergency_contact_name}" if Rails.env.development?
      end
    end
    @activities = ConsentActivity.where(week_id: @nearest_build_week&.id, hub_id: @learner.main_hub&.id)
                                 .order(meeting: :ASC)
                                 .order(Arel.sql("CASE day
                                                   WHEN 'Monday' THEN 1
                                                   WHEN 'Tuesday' THEN 2
                                                   WHEN 'Wednesday' THEN 3
                                                   WHEN 'Thursday' THEN 4
                                                   WHEN 'Friday' THEN 5
                                                   ELSE 6
                                                 END"))
    @consent_study_hub = ConsentStudyHub.find_by(week_id: @nearest_build_week&.id, hub_id: @learner.main_hub&.id)
  end

  def create_build_week
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    over_confirmed = params.dig(:consent, :confirmation_over_18) == '1'
    under_confirmed = params.dig(:consent, :confirmation_under_18) == '1'
    approver_present = params.dig(:consent, :consent_approved_by_learner).present? || params.dig(:consent, :consent_approved_by_guardian).present?

    unless over_confirmed || under_confirmed || approver_present
      @bw_consent = Consent.new
      flash.now[:alert] = "Please tick one of the confirmations or fill the name field."
      # Set required instance variables for the view
      @nearest_build_week = Week.where("end_date >= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
      @activities = ConsentActivity.where(week_id: @nearest_build_week&.id, hub_id: @learner.main_hub&.id)
                                   .order(meeting: :ASC)
                                   .order(Arel.sql("CASE day
                                                    WHEN 'Monday' THEN 1
                                                    WHEN 'Tuesday' THEN 2
                                                    WHEN 'Wednesday' THEN 3
                                                    WHEN 'Thursday' THEN 4
                                                    WHEN 'Friday' THEN 5
                                                    ELSE 6
                                                  END"))
      @consent_study_hub = ConsentStudyHub.find_by(week_id: @nearest_build_week&.id)
      render :build_week and return
    end

    # Use the same query as build_week to ensure consistency
    @nearest_build_week = Week.where("end_date >= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
    existing = Consent.find_by(user_id: @learner.id, week_id: @nearest_build_week&.id)

    consent_attrs = consent_params.merge(user: @learner, week: @nearest_build_week, hub: @learner.main_hub&.name)

    # Explicitly convert checkbox values to booleans
    # Rails checkboxes send "1" for checked, "0" or nothing for unchecked
    consent_attrs[:confirmation_over_18] = params.dig(:consent, :confirmation_over_18) == '1'
    consent_attrs[:confirmation_under_18] = params.dig(:consent, :confirmation_under_18) == '1'

    if existing
      # If there's an existing consent, update it with the form values
      @bw_consent = existing
      @bw_consent.assign_attributes(consent_attrs)
    else
      # First time filling - create new consent (fields already pre-populated from last consent in build_week method)
      @bw_consent = Consent.new(consent_attrs)
    end

    if @bw_consent.save
      redirect_to learner_profile_path(@learner), notice: "Consent saved."
    else
      flash.now[:alert] = @bw_consent.errors.full_messages.to_sentence
      # Set required instance variables for the view when rendering after error
      @activities = ConsentActivity.where(week_id: @nearest_build_week&.id, hub_id: @learner.main_hub&.id)
                                   .order(meeting: :ASC)
                                   .order(Arel.sql("CASE day
                                                    WHEN 'Monday' THEN 1
                                                    WHEN 'Tuesday' THEN 2
                                                    WHEN 'Wednesday' THEN 3
                                                    WHEN 'Thursday' THEN 4
                                                    WHEN 'Friday' THEN 5
                                                    ELSE 6
                                                   END"))
      @consent_study_hub = ConsentStudyHub.find_by(week_id: @nearest_build_week&.id)
      render :build_week
    end
  end

  def sprint
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end
    @hub = @learner.main_hub&.name

    # Handle date parameter for navigation
    begin
      @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      @current_date = Date.today
    end
    @current_date ||= Date.today

    # Find sprint for the current date, fallback to today's sprint if not found
    date_sprint = Sprint.where("start_date <= ? AND end_date >= ?", @current_date, @current_date).first
    @current_sprint = date_sprint || @current_sprint

    # Find previous and next sprints for navigation
    if @current_sprint
      @prev_sprint = Sprint.where("end_date < ?", @current_sprint.start_date).order(end_date: :desc).first
      @next_sprint = Sprint.where("start_date > ?", @current_sprint.end_date).order(:start_date).first
    else
      @prev_sprint = nil
      @next_sprint = nil
    end

    sprint_existing = Consent.find_by(user_id: @learner.id, sprint_id: @current_sprint&.id)

    if sprint_existing
      @sprint_consent = sprint_existing
    else
      # Get the most recent consent for this user to pre-populate fields
      last_consent = Consent.where(user_id: @learner.id).order(created_at: :desc).first

      Rails.logger.debug "Found last consent: #{last_consent.present?}" if Rails.env.development?
      Rails.logger.debug "Last consent ID: #{last_consent&.id}, emergency_contact_name: #{last_consent&.emergency_contact_name}" if Rails.env.development?

      # Create new consent with sprint dates
      @sprint_consent = Consent.new(
        user_id: @learner.id,
        sprint_id: @current_sprint&.id,
        hub: @learner.main_hub&.name,
        date: Date.today,
        start_date: @current_sprint&.start_date,
        end_date: @current_sprint&.end_date
      )

      # Populate common fields from the last consent
      if last_consent
        Rails.logger.debug "Populating fields from consent ID: #{last_consent.id}" if Rails.env.development?
        populate_common_fields(@sprint_consent, last_consent)
        Rails.logger.debug "After populate - emergency contact name: #{@sprint_consent.emergency_contact_name}" if Rails.env.development?
      end
    end
  end

  def create_sprint
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    # Require at least one confirmation or an approver name
    over_confirmed = params.dig(:consent, :confirmation_over_18) == '1'
    under_confirmed = params.dig(:consent, :confirmation_under_18) == '1'
    approver_present = params.dig(:consent, :approved_by_learner).present? || params.dig(:consent, :approved_by_guardian).present?

    unless over_confirmed || under_confirmed || approver_present
      @sprint_consent = Consent.new
      flash.now[:alert] = "Please tick one of the confirmations or fill the name field."
      render :sprint and return
    end


    existing = Consent.find_by(user_id: @learner.id, sprint_id: @current_sprint&.id)

    consent_attrs = consent_params.merge(user: @learner, sprint: @current_sprint, hub: @learner.main_hub&.name)

    if existing
      @sprint_consent = existing
      @sprint_consent.assign_attributes(consent_attrs)
    else
      @sprint_consent = Consent.new(consent_attrs)
    end

    if @sprint_consent.save
      redirect_to learner_profile_path(@learner), notice: "Consent saved."
    else
      flash.now[:alert] = @sprint_consent.errors.full_messages.to_sentence
      render :sprint
    end
  end

  def navigator
    begin
      @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      @current_date = Date.today
    end
    @current_date ||= Date.today

    # First, try to find a build week that contains the current date
    @current_build_week = Week.where("start_date <= ? AND end_date >= ? AND name ILIKE ?", @current_date, @current_date, "%Build%").first

    # If no build week found for current date, find the nearest one (past or future)
    if @current_build_week.nil?
      # Try to find the nearest past build week
      past_build_week = Week.where("end_date < ? AND name ILIKE ?", @current_date, "%Build%").order(end_date: :desc).first
      # Try to find the nearest future build week
      future_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_date, "%Build%").order(:start_date).first

      # Choose the closest one
      if past_build_week && future_build_week
        # If both exist, choose the one closest to current_date
        past_diff = (@current_date - past_build_week.end_date).abs
        future_diff = (future_build_week.start_date - @current_date).abs
        @current_build_week = past_diff < future_diff ? past_build_week : future_build_week
      elsif past_build_week
        @current_build_week = past_build_week
      elsif future_build_week
        @current_build_week = future_build_week
      else
        # If no build weeks exist at all, try to find any build week
        @current_build_week = Week.where("name ILIKE ?", "%Build%").order(:start_date).first
      end
    end

    if @current_build_week
      # Find previous build week
      @prev_build_week = Week.where("start_date < ? AND name ILIKE ?", @current_build_week.start_date, "%Build%").order(start_date: :desc).first

      # Find next build week
      @next_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_build_week.end_date, "%Build%").order(:start_date).first

      # Get available hubs for the current user
      @available_hubs = current_user.hubs.order(:name)

      # Get selected hub (default to main hub)
      selected_hub_id = params[:hub_id].presence || current_user.main_hub&.id
      @selected_hub = @available_hubs.find_by(id: selected_hub_id) || @available_hubs.first || current_user.main_hub

      # Find consent activities for the selected hub and build week
      @consent_activities = ConsentActivity.where(week_id: @current_build_week.id, hub_id: @selected_hub&.id).order(Arel.sql("CASE day
                                                    WHEN 'Monday' THEN 1
                                                    WHEN 'Tuesday' THEN 2
                                                    WHEN 'Wednesday' THEN 3
                                                    WHEN 'Thursday' THEN 4
                                                    WHEN 'Friday' THEN 5
                                                    ELSE 6
                                                   END"))

      # Find consent study hub for this week and selected hub
      @consent_study_hub = ConsentStudyHub.find_by(week_id: @current_build_week.id, hub_id: @selected_hub&.id)
    else
      @prev_build_week = nil
      @next_build_week = nil
      @consent_activities = []
      @consent_study_hub = nil
      @available_hubs = current_user.hubs.order(:name)
      @selected_hub = current_user.main_hub || @available_hubs.first
    end
  end

  def manage_activities
    begin
      @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      @current_date = Date.today
    end
    @current_date ||= Date.today

    # First, try to find a build week that contains the current date
    @current_build_week = Week.where("start_date <= ? AND end_date >= ? AND name ILIKE ?", @current_date, @current_date, "%Build%").first

    # If no build week found for current date, find the nearest one (past or future)
    if @current_build_week.nil?
      # Try to find the nearest past build week
      past_build_week = Week.where("end_date < ? AND name ILIKE ?", @current_date, "%Build%").order(end_date: :desc).first
      # Try to find the nearest future build week
      future_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_date, "%Build%").order(:start_date).first

      # Choose the closest one
      if past_build_week && future_build_week
        # If both exist, choose the one closest to current_date
        past_diff = (@current_date - past_build_week.end_date).abs
        future_diff = (future_build_week.start_date - @current_date).abs
        @current_build_week = past_diff < future_diff ? past_build_week : future_build_week
      elsif past_build_week
        @current_build_week = past_build_week
      elsif future_build_week
        @current_build_week = future_build_week
      else
        # If no build weeks exist at all, try to find any build week
        @current_build_week = Week.where("name ILIKE ?", "%Build%").order(:start_date).first
      end
    end

    if @current_build_week.nil?
      redirect_to navigator_consents_path, alert: "No build week found for this date."
      return
    end

    # Find previous and next build weeks for navigation
    @prev_build_week = Week.where("start_date < ? AND name ILIKE ?", @current_build_week.start_date, "%Build%").order(start_date: :desc).first
    @next_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_build_week.end_date, "%Build%").order(:start_date).first

    # Get available hubs for the current user
    @available_hubs = current_user.hubs.order(:name)
    @all_hubs = Hub.order(:name) # All hubs for the study hub dropdown

    # Get selected hub (default to main hub)
    selected_hub_id = params[:hub_id].presence || current_user.main_hub&.id
    @selected_hub = @available_hubs.find_by(id: selected_hub_id) || @available_hubs.first || current_user.main_hub

    # Find consent activities for the selected hub and build week
    @consent_activities = ConsentActivity.where(week_id: @current_build_week.id, hub_id: @selected_hub&.id).order(Arel.sql("CASE day
                                                    WHEN 'Monday' THEN 1
                                                    WHEN 'Tuesday' THEN 2
                                                    WHEN 'Wednesday' THEN 3
                                                    WHEN 'Thursday' THEN 4
                                                    WHEN 'Friday' THEN 5
                                                    ELSE 6
                                                   END"))

    # Find or initialize consent study hub for this week and selected hub
    @consent_study_hub = ConsentStudyHub.find_or_initialize_by(week_id: @current_build_week.id, hub_id: @selected_hub&.id)
  end

  def update_activities
    begin
      @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      @current_date = Date.today
    end
    @current_date ||= Date.today

    @current_build_week = Week.where("start_date <= ? AND end_date >= ? AND name ILIKE ?", @current_date, @current_date, "%Build%").first
    if @current_build_week.nil?
      redirect_to navigator_consents_path, alert: "No build week found for this date."
      return
    end

    selected_hub_id = params[:hub_id].presence || current_user.main_hub&.id
    selected_hub = current_user.hubs.find_by(id: selected_hub_id) || current_user.main_hub || current_user.hubs.first

    # Process each activity - permit the consent_activities hash first
    activities_params = params.permit(consent_activities: [:id, :day, :name, :activity_location, :meeting, :pick_up,
                                                          :location, :transport, :bring_along, :hub_id, :_destroy])[:consent_activities] || {}
    errors = []

    activities_params.each do |index, activity_params_hash|
      # activity_params_hash is already a permitted ActionController::Parameters object
      # Convert to hash for easier manipulation
      activity_hash = activity_params_hash.to_h

      if activity_hash[:_destroy] == "true" || activity_hash[:_destroy] == true
        # Delete activity
        if activity_hash[:id].present?
          activity = ConsentActivity.find_by(id: activity_hash[:id])
          activity&.destroy
        end
      else
        # Create or update activity
        if activity_hash[:id].present?
          activity = ConsentActivity.find_by(id: activity_hash[:id])
          if activity
            activity.assign_attributes(activity_hash.except(:id, :_destroy))
            activity.week_id = @current_build_week.id
            activity.hub_id = selected_hub&.id
            unless activity.save
              errors.concat(activity.errors.full_messages)
            end
          end
        else
          # Create new activity
          activity = ConsentActivity.new(activity_hash.except(:_destroy))
          activity.week_id = @current_build_week.id
          activity.hub_id = selected_hub&.id
          unless activity.save
            errors.concat(activity.errors.full_messages)
          end
        end
      end
    end

    # Process consent study hub - always try to save, even if params are empty
    study_hub_params = params.fetch(:consent_study_hub, {}).permit(:monday, :tuesday, :wednesday, :thursday, :friday, :hub_id)

    # Always set hub_id to the selected hub from the dropdown (required by model)
    selected_hub_id = selected_hub&.id

    # Find or initialize by both week_id and hub_id to create separate records for each hub
    @consent_study_hub = ConsentStudyHub.find_or_initialize_by(week_id: @current_build_week.id, hub_id: selected_hub_id)
    @consent_study_hub.assign_attributes(study_hub_params)
    @consent_study_hub.week_id = @current_build_week.id
    @consent_study_hub.hub_id = selected_hub_id

    unless @consent_study_hub.save
      errors.concat(@consent_study_hub.errors.full_messages)
    end

    if errors.empty?
      redirect_to navigator_consents_path(date: @current_build_week.start_date, hub_id: selected_hub_id), notice: "Activities saved successfully."
    else
      @available_hubs = current_user.hubs.order(:name)
      @all_hubs = Hub.order(:name)
      @selected_hub = selected_hub
      @prev_build_week = Week.where("start_date < ? AND name ILIKE ?", @current_build_week.start_date, "%Build%").order(start_date: :desc).first
      @next_build_week = Week.where("start_date > ? AND name ILIKE ?", @current_build_week.end_date, "%Build%").order(:start_date).first
      @consent_activities = ConsentActivity.where(week_id: @current_build_week.id, hub_id: @selected_hub&.id).order(Arel.sql("CASE day
                                                    WHEN 'Monday' THEN 1
                                                    WHEN 'Tuesday' THEN 2
                                                    WHEN 'Wednesday' THEN 3
                                                    WHEN 'Thursday' THEN 4
                                                    WHEN 'Friday' THEN 5
                                                    ELSE 6
                                                   END"))
      @consent_study_hub = ConsentStudyHub.find_or_initialize_by(week_id: @current_build_week.id)
      flash.now[:alert] = errors.join(", ")
      render :manage_activities, status: :unprocessable_entity
    end
  end


  private

  def populate_common_fields(target_consent, source_consent)
    # Hub information
    target_consent.hub = source_consent.hub

    # Emergency contact information
    target_consent.emergency_contact_name = source_consent.emergency_contact_name
    target_consent.emergency_contact_relationship = source_consent.emergency_contact_relationship
    target_consent.emergency_contact_contact = source_consent.emergency_contact_contact
    target_consent.emergency_contact_email = source_consent.emergency_contact_email

    # Family doctor and insurance information
    target_consent.family_doctor_name = source_consent.family_doctor_name
    target_consent.family_doctor_contact = source_consent.family_doctor_contact
    target_consent.work_adress = source_consent.work_adress
    target_consent.utente_number = source_consent.utente_number
    target_consent.health_insurance_plan = source_consent.health_insurance_plan
    target_consent.health_insurance_contact = source_consent.health_insurance_contact

    # Other emergency contacts
    target_consent.emergency_contact_name_1 = source_consent.emergency_contact_name_1
    target_consent.emergency_contact_contact_1 = source_consent.emergency_contact_contact_1
    target_consent.emergency_contact_name_2 = source_consent.emergency_contact_name_2
    target_consent.emergency_contact_contact_2 = source_consent.emergency_contact_contact_2
    target_consent.emergency_contact_name_3 = source_consent.emergency_contact_name_3
    target_consent.emergency_contact_contact_3 = source_consent.emergency_contact_contact_3
    target_consent.emergency_contact_name_4 = source_consent.emergency_contact_name_4
    target_consent.emergency_contact_contact_4 = source_consent.emergency_contact_contact_4

    # Medical information
    target_consent.allergies = source_consent.allergies
    target_consent.diet = source_consent.diet
    target_consent.limitations = source_consent.limitations
    target_consent.medication = source_consent.medication
    target_consent.additional_info = source_consent.additional_info
  end

  def consent_params
    params.require(:consent).permit(
      :hub,
      :date,
      :start_date,
      :end_date,
      :confirmation_under_18,
      :confirmation_over_18,
      :emergency_contact_name,
      :emergency_contact_relationship,
      :emergency_contact_contact,
      :emergency_contact_email,
      :family_doctor_name,
      :family_doctor_contact,
      :work_adress,
      :utente_number,
      :health_insurance_plan,
      :health_insurance_contact,
      :emergency_contact_name_1,
      :emergency_contact_contact_1,
      :emergency_contact_name_2,
      :emergency_contact_contact_2,
      :emergency_contact_name_3,
      :emergency_contact_contact_3,
      :emergency_contact_name_4,
      :emergency_contact_contact_4,
      :allergies,
      :diet,
      :limitations,
      :medication,
      :additional_info,
      :consent_approved_by_learner,
      :consent_approved_by_guardian
    )
  end

  def set_current_sprint
    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
  end

  def set_learner
    learner_id = params[:learner_id]
    @learner = learner_id.present? ? User.find_by(id: learner_id) : current_user.kids.first
  end

  def ensure_lc_or_admin
    unless current_user.role == 'lc' || current_user.role == 'admin'
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
