class AddUniqueIndexToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_index :weekly_goals, [:user_id, :week_id], unique: true
  end
end
