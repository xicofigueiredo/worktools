class CreateStaffLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_leaves do |t|
      t.string :leave_type, null: false
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :total_days, null: false
      t.references :approver_user, foreign_key: { to_table: :users }
      t.datetime :approved_at
      t.boolean :exception_requested, default: false, null: false
      t.text :exception_reason
      t.text :notes
      t.string :status, null: false, default: 'pending'
      t.timestamps
    end

    add_index :staff_leaves, :start_date
    add_index :staff_leaves, :status
    add_index :staff_leaves, [:user_id, :start_date]
  end
end
