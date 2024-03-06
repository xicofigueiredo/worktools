class RemoveStartEndDateFromWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    remove_column :weekly_goals, :start_date, :date
    remove_column :weekly_goals, :end_date, :date
    add_reference :weekly_goals, :week, foreign_key: true
  end
end
