class RemoveRemindersFromConfirmations < ActiveRecord::Migration[7.0]
  def change
    remove_column :confirmations, :reminder_3_sent_at, :datetime
    remove_column :confirmations, :reminder_5_sent_at, :datetime
  end
end
