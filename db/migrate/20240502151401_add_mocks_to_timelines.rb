class AddMocksToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :mock50, :datetime
    add_column :timelines, :mock100, :datetime
  end
end
