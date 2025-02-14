class AddMoodleIdToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :moodle_id, :integer
  end
end
