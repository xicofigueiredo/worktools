class AddRejectionReasonToConfirmations < ActiveRecord::Migration[7.0]
  def change
    add_column :confirmations, :rejection_reason, :text
  end
end
