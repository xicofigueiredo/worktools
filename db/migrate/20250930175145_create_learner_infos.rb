class CreateLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :learner_infos do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      # Basic / identity
      t.string  :status
      t.bigint  :student_number, index: true
      t.string  :programme
      t.string  :full_name
      t.string  :curriculum_course_option
      t.string  :grade_year

      # Dates
      t.date    :start_date
      t.date    :transfer_of_programme_date
      t.date    :end_date
      t.string  :end_day_communication

      # Personal / contact
      t.date    :birthdate
      t.string  :personal_email
      t.string  :institutional_email
      t.string  :phone_number
      t.string  :nationality
      t.string  :id_information
      t.bigint  :fiscal_number
      t.boolean :english_proficiency

      t.text    :home_address
      t.string  :gender
      t.boolean :use_of_image_authorisation
      t.boolean :emergency_protocol_choice

      # Parent 1 (Section 6)
      t.string  :parent1_full_name
      t.string  :parent1_email
      t.string  :parent1_phone_number
      t.string  :parent1_id_information

      # Parent 2 (Section 6)
      t.string  :parent2_full_name
      t.string  :parent2_email
      t.string  :parent2_phone_number
      t.string  :parent2_id_information
      t.text    :parent2_info_not_to_be_contacted

      # Registration / finance
      t.integer :registration_renewal
      t.date    :registration_renewal_date
      t.string  :deposit
      t.string  :sponsor
      t.string  :payment_plan
      t.integer :monthly_tuition
      t.string  :discount_mt
      t.string  :scholarship
      t.integer :billable_fee_per_month
      t.integer :scholarship_percentage
      t.integer :admission_fee
      t.integer :discount_af
      t.integer :billable_af

      # School / previous schooling
      t.string  :registering_school_pt_plus
      t.string  :previous_schooling
      t.string  :previous_school_status
      t.string  :previous_school_name
      t.string  :previous_school_email

      # Withdrawal
      t.string  :withdrawal_category
      t.text    :withdrawal_reason

      t.timestamps
    end
  end
end
