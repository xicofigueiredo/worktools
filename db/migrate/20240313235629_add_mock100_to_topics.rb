class AddMock100ToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :Mock100, :boolean
  end
end
