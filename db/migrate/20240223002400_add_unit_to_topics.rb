class AddUnitToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :unit, :string
  end
end
