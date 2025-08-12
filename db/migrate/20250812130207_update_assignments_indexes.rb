class UpdateAssignmentsIndexes < ActiveRecord::Migration[7.0]
  def change
    # Remove old unique index on moodle_id if it exists
    if index_exists?(:assignments, :moodle_id, unique: true)
      remove_index :assignments, column: :moodle_id
    end

    # Ensure helper indexes exist
    add_index :assignments, :moodle_id unless index_exists?(:assignments, :moodle_id)
    add_index :assignments, :moodle_course_id unless index_exists?(:assignments, :moodle_course_id)

    # Add composite unique index to allow one row per user per Moodle assignment and subject
    unless index_exists?(:assignments, [:user_id, :subject_id, :moodle_id], unique: true)
      add_index :assignments, [:user_id, :subject_id, :moodle_id], unique: true, name: 'index_assignments_on_user_subject_moodle'
    end
  end
end
