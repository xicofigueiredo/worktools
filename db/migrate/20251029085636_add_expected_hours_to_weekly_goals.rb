class AddExpectedHoursToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :weekly_goals, :expected_hours, :float
  end
end
