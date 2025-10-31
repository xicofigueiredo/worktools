class AddHiddenToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :hidden, :boolean, default: false, null: false
  end
end
