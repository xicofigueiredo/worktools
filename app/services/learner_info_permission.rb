class LearnerInfoPermission
  attr_reader :user, :record, :role

  LEARNER_VIEW_BY_ROLE = {
    'admin' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number home_address
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number parent1_id_information
      parent2_full_name parent2_email parent2_phone_number parent2_id_information
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year id_information
      fiscal_number start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice data_validated
      withdrawal_category withdrawal_reason onboarding_meeting_notes notes
    ],
    'admissions' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number home_address
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number parent1_id_information
      parent2_full_name parent2_email parent2_phone_number parent2_id_information
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year id_information
      fiscal_number start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice data_validated
      withdrawal_category withdrawal_reason onboarding_meeting_notes notes
    ],
    'edu' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number
      parent2_full_name parent2_email parent2_phone_number
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year
      start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice
      withdrawal_reason onboarding_meeting_notes notes
    ],
    'finance' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number parent1_id_information
      parent2_full_name parent2_email parent2_phone_number parent2_id_information
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year id_information
      fiscal_number start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice data_validated
      withdrawal_category withdrawal_reason onboarding_meeting_notes notes
    ],
    'ops' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number parent1_id_information
      parent2_full_name parent2_email parent2_phone_number parent2_id_information
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year id_information
      fiscal_number start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice data_validated
      withdrawal_category withdrawal_reason onboarding_meeting_notes notes
    ],
    'it' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number
      parent2_full_name parent2_email parent2_phone_number
      parent2_info_not_to_be_contacted
      start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice
      onboarding_meeting_notes notes
    ],
    'lc' => %i[
      full_name preferred_name student_number status birthdate programme
      learning_coach_id hub_id curriculum_course_option grade_year
      personal_email institutional_email phone_number
      nationality gender native_language english_proficiency
      parent1_full_name parent1_email parent1_phone_number
      parent2_full_name parent2_email parent2_phone_number
      parent2_info_not_to_be_contacted registering_school_pt_plus
      previous_schooling previous_school_status previous_school_name
      previous_school_email previous_school_grade_year
      start_date transfer_of_programme_date end_date
      end_day_communication platform_username platform_password
      use_of_image_authorisation emergency_protocol_choice
      onboarding_meeting_notes notes
    ]
  }.freeze

  LEARNER_EDIT_BY_ROLE = {
    'admin' => LEARNER_VIEW_BY_ROLE['admin'],
    'admissions' => LEARNER_VIEW_BY_ROLE['admissions'],
    'edu' => %i[preferred_name learning_coach_id personal_email phone_number english_proficiency notes],
    'finance' => %i[preferred_name],
    'ops' => [],
    'it' => %i[preferred_name platform_username platform_password],
    'lc' => %i[preferred_name learning_coach_id personal_email phone_number parent1_phone_number parent2_phone_number]
  }.freeze

  FINANCE_VIEW_BY_ROLE = {
    'admin' => %i[
      payment_plan financial_responsibility monthly_fee discount_mf scholarship
      billable_mf admission_fee discount_af billable_af
      renewal_fee discount_rf billable_rf
    ],
    'admissions' => %i[
      payment_plan financial_responsibility monthly_fee discount_mf scholarship
      billable_mf admission_fee discount_af billable_af
      renewal_fee discount_rf billable_rf
    ],
    'edu' => [],
    'finance' => %i[
      payment_plan financial_responsibility monthly_fee discount_mf scholarship
      billable_mf admission_fee discount_af billable_af
      renewal_fee discount_rf billable_rf
    ],
    'ops' => %i[
      payment_plan financial_responsibility monthly_fee discount_mf scholarship
      billable_mf admission_fee discount_af billable_af
      renewal_fee discount_rf billable_rf
    ],
    'it' => [],
    'lc' => []
  }.freeze

  FINANCE_EDIT_BY_ROLE = {
    'admin' => FINANCE_VIEW_BY_ROLE['admin'],
    'admissions' => FINANCE_VIEW_BY_ROLE['admissions'],
    'edu' => [],
    'finance' => %i[payment_plan financial_responsibility discount_mf scholarship discount_af discount_rf],
    'ops' => [],
    'it' => [],
    'lc' => []
  }.freeze

  def initialize(user, record)
    @user = user
    @record = record
    @role = user&.role
  end

  def show?
    admin? || admissions? || edu? || finance? || ops? || it? || lc?
  end

  def update?
    permitted_attributes.any? || finance_permitted_attributes.any?
  end

  def destroy?
    admin?
  end

  def finance_visible?
    visible_finance_fields.any?
  end

  def visible_learner_fields
    LEARNER_VIEW_BY_ROLE[@role] || []
  end

  def visible_finance_fields
    FINANCE_VIEW_BY_ROLE[@role] || []
  end

  def permitted_attributes
    LEARNER_EDIT_BY_ROLE[@role] || []
  end

  def finance_permitted_attributes
    FINANCE_EDIT_BY_ROLE[@role] || []
  end

  def editable_field?(attr_name)
    permitted_attributes.include?(attr_name.to_sym)
  end

  private

  def admin? = @role == 'admin'
  def admissions? = @role == 'admissions'
  def edu? = @role == 'edu'
  def finance? = @role == 'finance'
  def ops? = @role == 'ops'
  def it? = @role == 'it'
  def lc? = @role == 'lc'
end
