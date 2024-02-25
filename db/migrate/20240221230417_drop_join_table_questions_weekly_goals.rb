class DropJoinTableQuestionsWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    drop_join_table :questions, :weekly_goals
  end
end
