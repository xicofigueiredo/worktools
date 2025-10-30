class AddMoodleRefsToSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :moodle_submission_id, :bigint, null: false
    add_column :submissions, :moodle_assignment_id, :bigint, null: false

    add_index :submissions, :moodle_submission_id, unique: true
    add_index :submissions, :moodle_assignment_id

    add_foreign_key :submissions, :moodle_assignments, column: :moodle_assignment_id
  end
end
