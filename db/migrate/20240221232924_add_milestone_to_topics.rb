class AddMilestoneToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :milestone, :boolean
  end
end
