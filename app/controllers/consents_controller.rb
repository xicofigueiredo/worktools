class ConsentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_sprint
  before_action :set_learner

  def build_week
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    # Find the nearest build week week.name.include?("Build") and start_date is before or equal to Date.today
    @nearest_build_week = Week.where("start_date >= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
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
      render :build_week and return
    end

    @nearest_build_week = Week.where("start_date <= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
    existing = Consent.find_by(user_id: @learner.id, week_id: @nearest_build_week&.id)

    consent_attrs = consent_params.merge(user: @learner, week: @nearest_build_week, hub: @learner.main_hub&.name)

    if existing
      @bw_consent = existing
      @bw_consent.assign_attributes(consent_attrs)
    else
      @bw_consent = Consent.new(consent_attrs)
    end

    if @bw_consent.save
      redirect_to learner_profile_path(@learner), notice: "Consent saved."
    else
      flash.now[:alert] = @bw_consent.errors.full_messages.to_sentence
      render :build_week
    end
  end

  def sprint
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end
    @hub = @learner.main_hub&.name

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
end
