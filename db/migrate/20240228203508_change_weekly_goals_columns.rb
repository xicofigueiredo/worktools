class ChangeWeeklyGoalsColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :weekly_goals, :day_of_week, :integer
    remove_column :weekly_goals, :time_slot, :integer
    add_column :weekly_goals, :name, :string
  end
end
