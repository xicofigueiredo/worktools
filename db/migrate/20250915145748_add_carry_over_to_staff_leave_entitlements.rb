class AddCarryOverToStaffLeaveEntitlements < ActiveRecord::Migration[7.0]
  def change
    add_column :staff_leave_entitlements, :carry_over_days, :integer, default: 0, null: false
  end
end
