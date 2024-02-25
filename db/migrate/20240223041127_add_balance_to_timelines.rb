class AddBalanceToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :balance, :integer
  end
end
