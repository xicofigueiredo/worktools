class AddMoodleIdToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :moodle_id, :bigint
  end
end
