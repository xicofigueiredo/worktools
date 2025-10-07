class LearnerInfoPermission
  attr_reader :user, :record

  EDU_HIDDEN_FIELDS = %i[
    end_day_communication personal_email phone_number nationality id_information
    fiscal_number home_address gender use_of_image_authorisation
    parent1_phone_number parent1_id_information parent2_email parent2_phone_number
    parent2_id_information parent2_info_not_to_be_contacted registration_renewal
    registration_renewal_date deposit sponsor payment_plan monthly_tuition
    discount_mt scholarship billable_fee_per_month scholarship_percentage admission_fee
    discount_af billable_af registering_school_pt_plus previous_schooling
    previous_school_status previous_school_email native_language preferred_name
  ].freeze

  ADMISSIONS_EDITABLE = %i[
    programme preferred_name full_name curriculum_course_option grade_year start_date
    transfer_of_programme_date end_date end_day_communication personal_email phone_number
    id_information fiscal_number home_address gender use_of_image_authorisation
    emergency_protocol_choice parent1_email parent1_phone_number parent1_id_information
    parent2_email parent2_phone_number parent2_id_information parent2_info_not_to_be_contacted
    deposit sponsor payment_plan discount_mt scholarship_percentage admission_fee discount_af
    preferred_name native_language monthly_tuition billable_fee_per_month
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

  def visible_fields
    if admin? || admissions?
      LearnerInfo.column_names.map(&:to_sym)
    elsif edu?
      LearnerInfo.column_names.map(&:to_sym) - EDU_HIDDEN_FIELDS
    else
      %i[id full_name programme grade_year start_date birthdate].freeze
    end
  end

  def permitted_attributes
    return visible_fields if admin?
    return ADMISSIONS_EDITABLE if admissions?

    []
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
