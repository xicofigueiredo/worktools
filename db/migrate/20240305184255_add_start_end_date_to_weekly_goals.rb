class AddStartEndDateToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :weekly_goals, :start_date, :date
    add_column :weekly_goals, :end_date, :date
    remove_reference :weekly_goals, :week, foreign_key: true
  end
end
