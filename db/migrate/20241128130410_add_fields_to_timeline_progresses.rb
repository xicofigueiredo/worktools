class AddFieldsToTimelineProgresses < ActiveRecord::Migration[7.0]
  def change
    add_column :timeline_progresses, :expected, :integer, default: 0, null: false
    add_column :timeline_progresses, :difference, :integer, default: 0, null: false
  end
end
