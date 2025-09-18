class AddDaysFromPreviousYearToStaffLeaves < ActiveRecord::Migration[7.0]
  def change
    add_column :staff_leaves, :days_from_previous_year, :integer, default: 0, null: false
    add_index :staff_leaves, :days_from_previous_year
  end
end
