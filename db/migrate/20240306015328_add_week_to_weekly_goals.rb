class AddWeekToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :weekly_goals, :week, null: true, foreign_key: true
  end
end
