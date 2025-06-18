class AddBlocksToMoodleTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_timelines, :blocks, :boolean, array: true, default: [false, false, false, false]
  end
end
