class AddFieldsToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :grade, :float, null: true
    add_column :moodle_topics, :done, :boolean, default: false, null: false
    add_column :moodle_topics, :completion_date, :datetime, null: true
  end
end
