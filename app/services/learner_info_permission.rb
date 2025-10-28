class LearnerInfoPermission
  attr_reader :user, :record

  EDU_HIDDEN_FIELDS = %i[
    end_day_communication personal_email phone_number nationality id_information
    fiscal_number home_address gender use_of_image_authorisation
    parent1_phone_number parent1_id_information parent2_email parent2_phone_number
    parent2_id_information parent2_info_not_to_be_contacted registration_renewal_date
    registering_school_pt_plus previous_schooling
    previous_school_status previous_school_email native_language preferred_name
  ].freeze

  ADMISSIONS_EDITABLE = %i[
    programme preferred_name full_name curriculum_course_option grade_year start_date
    transfer_of_programme_date end_date end_day_communication personal_email phone_number
    id_information fiscal_number home_address gender use_of_image_authorisation
    emergency_protocol_choice parent1_email parent1_phone_number parent1_id_information
    parent2_email parent2_phone_number parent2_id_information parent2_info_not_to_be_contacted
    preferred_name native_language onboarding_meeting_notes # NEW: Added to allow admissions to edit
  ].freeze

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    admin? || admissions? || edu?
  end

  def update?
    admin? || admissions?
  end

  def destroy?
    admin?
  end

  def finance_visible?
    admin? || admissions?
  end

  def visible_learner_fields
    if admin? || admissions?
      LearnerInfo.column_names.map(&:to_sym)
    elsif edu?
      LearnerInfo.column_names.map(&:to_sym) - EDU_HIDDEN_FIELDS
    else
      %i[id full_name programme grade_year start_date birthdate].freeze
    end
  end

  def visible_finance_fields
    if finance_visible?
      LearnerFinance.column_names.map(&:to_sym) - %i[id learner_info_id created_at updated_at]
    else
      []
    end
  end

  def permitted_attributes
    return visible_learner_fields if admin?
    return ADMISSIONS_EDITABLE if admissions?

    []
  end

  def finance_permitted_attributes
    if admin? || admissions?
      visible_finance_fields
    else
      []
    end
  end

  def editable_field?(attr_name)
    permitted_attributes.map(&:to_sym).include?(attr_name.to_sym)
  end

  private

  def admin?
    user.present? && user.role == 'admin'
  end

  def admissions?
    user.present? && user.role == 'admissions'
  end

  def edu?
    user.present? && user.role == 'edu'
  end
end
