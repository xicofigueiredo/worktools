class AddWeeklyGoalToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendances, :weekly_goal, null: true, foreign_key: true
  end
end
