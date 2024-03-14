class RenameExpectedBalanceToProgressInTimelines < ActiveRecord::Migration[7.0]
  def change
    rename_column :timelines, :expected_balance, :progress
  end
end
