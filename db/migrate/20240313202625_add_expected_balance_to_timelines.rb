class AddExpectedBalanceToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :expected_balance, :integer
  end
end
