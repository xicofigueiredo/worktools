class AddCreatorToBlockedPeriods < ActiveRecord::Migration[7.0]
  def change
    add_reference :blocked_periods, :creator, foreign_key: { to_table: :users }
  end
end
