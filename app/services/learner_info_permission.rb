class LearnerInfoPermission
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    admin? || admissions?
  end

  def update?
    admin? || admissions?
  end

  def destroy?
    admin?
  end

  def visible_fields
    %i[
      programme preferred_name full_name curriculum_course_option grade_year start_date
      transfer_of_programme_date end_date end_day_communication personal_email phone_number
      id_information fiscal_number home_address gender use_of_image_authorisation
      emergency_protocol_choice parent1_email parent1_phone_number parent1_id_information
      parent2_email parent2_phone_number parent2_id_information parent2_info_not_to_be_contacted
      deposit sponsor payment_plan discount_mt scholarship_percentage admission_fee discount_af
      preferred_name native_language monthly_tuition billable_fee_per_month billable_af
      student_number birthdate institutional_email nationality registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name previous_school_email
      parent1_full_name parent1_id_information parent2_full_name parent2_id_information
      withdrawal_category withdrawal_reason
    ]
  end

  def permitted_attributes
    return visible_fields if admin?

    %i[
      programme preferred_name full_name curriculum_course_option grade_year start_date
      transfer_of_programme_date end_date end_day_communication personal_email phone_number
      id_information fiscal_number home_address gender use_of_image_authorisation
      emergency_protocol_choice parent1_email parent1_phone_number parent1_id_information
      parent2_email parent2_phone_number parent2_id_information parent2_info_not_to_be_contacted
      deposit sponsor payment_plan discount_mt scholarship_percentage admission_fee discount_af
      preferred_name native_language monthly_tuition billable_fee_per_month
    ].uniq
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
end
