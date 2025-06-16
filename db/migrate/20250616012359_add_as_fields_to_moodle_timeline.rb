class AddAsFieldsToMoodleTimeline < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_timelines, :as1, :boolean
    add_column :moodle_timelines, :as2, :boolean
  end
end
