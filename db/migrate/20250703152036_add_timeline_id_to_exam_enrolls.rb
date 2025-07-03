class AddTimelineIdToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    # Add new timeline_id column
    add_column :exam_enrolls, :timeline_id, :integer, null: true
    add_index :exam_enrolls, :timeline_id

    # Make moodle_timeline_id optional by removing not null constraint if it exists
    change_column_null :exam_enrolls, :moodle_timeline_id, true

    # Add foreign key for timeline_id if you have a timelines table
    add_foreign_key :exam_enrolls, :timelines, column: :timeline_id, on_delete: :nullify, optional: true
  end
end
