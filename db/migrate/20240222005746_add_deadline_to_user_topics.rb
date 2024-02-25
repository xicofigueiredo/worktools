class AddDeadlineToUserTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :user_topics, :deadline, :date
  end
end
