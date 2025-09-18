class AddDepartmentToBlockedPeriods < ActiveRecord::Migration[7.0]
  def change
    add_reference :blocked_periods, :department, foreign_key: true
  end
end
