class AddPercentageToUserTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :user_topics, :percentage, :float
  end
end
