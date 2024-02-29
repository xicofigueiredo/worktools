class AddDayOfWeekAndTimeSlotToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :weekly_goals, :day_of_week, :integer
    add_column :weekly_goals, :time_slot, :integer
  end
end
