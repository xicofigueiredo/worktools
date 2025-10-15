class ReplaceSickLeavesLeftWithSickLeavesUsed < ActiveRecord::Migration[6.1]
  def up
    add_column :staff_leave_entitlements, :sick_leaves_used, :integer, default: 0, null: false

    if column_exists?(:staff_leave_entitlements, :sick_leaves_left)
      remove_column :staff_leave_entitlements, :sick_leaves_left
    end

    if column_exists?(:staff_leave_entitlements, :carry_over_days)
      remove_column :staff_leave_entitlements, :carry_over_days
    end
  end

  def down
    add_column :staff_leave_entitlements, :sick_leaves_left, :integer, default: 5, null: false unless column_exists?(:staff_leave_entitlements, :sick_leaves_left)
    add_column :staff_leave_entitlements, :carry_over_days, :integer unless column_exists?(:staff_leave_entitlements, :carry_over_days)

    remove_column :staff_leave_entitlements, :sick_leaves_used if column_exists?(:staff_leave_entitlements, :sick_leaves_used)
  end
end
