class CreateJoinTableWeeklyGoalsQuestions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :weekly_goals, :questions do |t|
      t.index [:weekly_goal_id, :question_id]
      t.index [:question_id, :weekly_goal_id]
    end
  end
end
