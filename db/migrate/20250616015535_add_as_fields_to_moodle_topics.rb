class AddAsFieldsToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :as1, :boolean
    add_column :moodle_topics, :as2, :boolean
  end
end
