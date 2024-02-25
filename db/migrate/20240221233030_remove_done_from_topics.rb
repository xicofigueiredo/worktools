class RemoveDoneFromTopics < ActiveRecord::Migration[7.0]
  def change
    remove_column :topics, :done, :boolean
  end
end
