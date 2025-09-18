class CreateConfirmations < ActiveRecord::Migration[7.0]
  def change
    create_table :confirmations do |t|
      t.string :type, null: false
      t.references :staff_leave, null: false, foreign_key: true
      t.references :approver, null: false, foreign_key: { to_table: :users }
      t.datetime :validated_at
      t.string :status, default: 'pending', null: false
      t.datetime :reminder_3_sent_at
      t.datetime :reminder_5_sent_at
      t.timestamps
    end

    add_index :confirmations, [:staff_leave_id, :approver_id]
  end
end
