class AddAnnualHolidays < ActiveRecord::Migration[7.0]
  def change
    add_column :staff_leave_entitlements, :annual_holidays, :integer, default: 25
  end
end
