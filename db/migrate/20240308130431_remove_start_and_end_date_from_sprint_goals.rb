class RemoveStartAndEndDateFromSprintGoals < ActiveRecord::Migration[7.0]
  def change
    remove_column :sprint_goals, :start_date, :date
    remove_column :sprint_goals, :end_date, :date
  end
end
