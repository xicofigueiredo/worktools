class AddMockAndCompletionFieldsToMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :moodle_topics, :mock50, :boolean, default: false
    add_column :moodle_topics, :mock100, :boolean, default: false
    add_column :moodle_topics, :completion_data, :integer
    add_column :moodle_topics, :submission_date, :string
    add_column :moodle_topics, :evaluation_date, :string
    add_column :moodle_topics, :number_attempts, :integer, default: 0
  end
end
