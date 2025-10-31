class AddGradingTimeToMoodleAssignments < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_assignments, :grading_time, :decimal, precision: 8, scale: 2
    add_index :moodle_assignments, :grading_time
  end
end
