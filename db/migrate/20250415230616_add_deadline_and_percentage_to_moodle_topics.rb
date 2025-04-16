class AddDeadlineAndPercentageToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :deadline, :date
    add_column :moodle_topics, :percentage, :float
  end
end
