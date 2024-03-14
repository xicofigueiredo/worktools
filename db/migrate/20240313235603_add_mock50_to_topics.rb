class AddMock50ToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :Mock50, :boolean
  end
end
