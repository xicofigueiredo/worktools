class ChangeTimeFormatInTopics < ActiveRecord::Migration[7.0]
  def up
    # Change the time column to decimal with specified precision and scale
    change_column :topics, :time, :decimal, precision: 5, scale: 2
  end

  def down
    change_column :topics, :time, :integer
  end
end
