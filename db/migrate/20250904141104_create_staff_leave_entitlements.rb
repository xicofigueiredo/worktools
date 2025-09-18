class CreateStaffLeaveEntitlements < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_leave_entitlements do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :holidays_left, default: 25, null: false
      t.integer :sick_leaves_left, default: 5, null: false

      t.timestamps
    end

    add_index :staff_leave_entitlements, [:user_id, :year], unique: true
  end
end
