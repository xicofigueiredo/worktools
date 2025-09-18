class AddDaysFromPreviousYearUsedToStaffLeaveEntitlements < ActiveRecord::Migration[7.0]
  def change
    add_column :staff_leave_entitlements, :days_from_previous_year_used, :integer, default: 0, null: false
  end
end
