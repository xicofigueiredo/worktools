class AddMoodleIdToMoodleTimeline < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_timelines, :moodle_id, :integer
  end
end
