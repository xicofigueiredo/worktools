class AddOrderToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :order, :integer
  end
end
