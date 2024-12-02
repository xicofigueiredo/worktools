class AddDifferenceToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :difference, :integer
  end
end
