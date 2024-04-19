class AddTimelineToUserTopics < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_topics, :timeline, null: true, foreign_key: true
  end
end
