class AddAnoFieldsToMoodleTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_timelines, :ano10, :boolean
    add_column :moodle_timelines, :ano11, :boolean
    add_column :moodle_timelines, :ano12, :boolean
  end
end
