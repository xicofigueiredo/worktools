class ChangeLearnigCoachFieldsInExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    # Remove learning_coach_email column
    remove_column :exam_enrolls, :learning_coach_email, :string

    # Remove the existing learning_coach column
    remove_column :exam_enrolls, :learning_coach, :string

    # Add new learning_coach_ids column as integer array
    add_column :exam_enrolls, :learning_coach_ids, :integer, array: true, default: []

  end
end
