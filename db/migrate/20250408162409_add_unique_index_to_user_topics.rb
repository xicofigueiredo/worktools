class AddUniqueIndexToUserTopics < ActiveRecord::Migration[7.0]
  def change
    add_index :user_topics, [:user_id, :topic_id], unique: true
  end
end
