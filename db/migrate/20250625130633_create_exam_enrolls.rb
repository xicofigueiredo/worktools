class CreateExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_enrolls do |t|
      # Personal info
      t.string :hub
      t.string :learning_coach
      t.string :learning_coach_email
      t.string :learner_name
      t.string :learner_id_type
      t.string :learner_id_number
      t.date :date_of_birth
      t.string :gender
      t.boolean :native_language_english
      # Academic info
      t.string :subject_name
      t.integer :code
      t.string :qualification
      t.string :progress_cut_off
      t.string :mock_results
      t.string :bga_exam_centre
      t.string :exam_board
      t.boolean :has_special_accommodations
      # t.boolean :special_accommodations_types, array: true, default: [false, false, false, false]
      t.string :special_accommodations_personalized
      t.string :additional_comments
      # Extension
      t.string :extension_justification
      t.boolean :extension_cm_approval
      t.string :extension_cm_comment
      t.boolean :extension_edu_approval
      t.string :extension_edu_comment

      # Exception
      t.string :exception_justification
      t.boolean :exception_cm_approval
      t.string :exception_cm_comment
      t.boolean :exception_edu_approval
      t.string :exception_edu_comment


      t.timestamps
    end
  end
end
