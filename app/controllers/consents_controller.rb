class ConsentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_sprint
  before_action :set_learner

  def build_week
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    # Find the nearest build week week.name.include?("Build") and start_date is before or equal to Date.today
    @nearest_build_week = Week.where("start_date <= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
    bw_existing = Consent.find_by(user_id: @learner.id, week_id: @nearest_build_week&.id)
    if bw_existing
      @bw_consent = bw_existing
    else
      @bw_consent = Consent.new(
        user_id: @learner.id,
        week_id: @nearest_build_week&.id,
        hub: @learner.main_hub&.name,
        start_date: @nearest_build_week&.start_date,
        end_date: @nearest_build_week&.end_date
      )
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
      @sprint_consent = Consent.new(user_id: @learner.id, sprint_id: @current_sprint&.id, hub: @learner.main_hub&.name, date: Date.today)
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

    consent_attrs = consent_params.merge(user: @learner, sprint: @current_sprint)

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
