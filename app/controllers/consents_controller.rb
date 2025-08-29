class ConsentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_sprint
  before_action :set_learner

  def build_week
  end

  def sprint
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end
    @hub = @learner.main_hub&.name

    existing = Consent.find_by(user_id: @learner.id, sprint_id: @current_sprint&.id)
    if existing
      redirect_to edit_sprint_consents_path(@learner)
    end

    @consent = Consent.new(hub: @learner.main_hub&.name, date: Date.today)
  end

  def create_sprint
    if @learner.nil?
      redirect_back fallback_location: root_path, alert: "Learner not found" and return
    end

    if Consent.exists?(user_id: @learner.id, sprint_id: @current_sprint&.id)
      redirect_to  edit_sprint_consents_path(@learner)
    end

    # Require at least one confirmation or an approver name
    over_confirmed = params.dig(:consent, :confirmation_over_18) == '1'
    under_confirmed = params.dig(:consent, :confirmation_under_18) == '1'
    approver_present = params.dig(:consent, :consent_approved_by).present?

    unless over_confirmed || under_confirmed || approver_present
      @consent = Consent.new
      flash.now[:alert] = "Please tick one of the confirmations or fill the name field."
      render :sprint and return
    end

    approver = params.dig(:consent, :consent_approved_by).presence

    filtered_params = consent_params.merge(consent_approved_by: approver)

    @consent = Consent.new(filtered_params.merge(user: @learner, sprint: @current_sprint))

    if @consent.save
      redirect_to learner_profile_path(@learner), notice: "Consent saved."
    else
      flash.now[:alert] = @consent.errors.full_messages.to_sentence
      render :sprint
    end
  end

  private

  def consent_params
    params.require(:consent).permit(
      :hub,
      :date,
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
      :consent_approved_by
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
