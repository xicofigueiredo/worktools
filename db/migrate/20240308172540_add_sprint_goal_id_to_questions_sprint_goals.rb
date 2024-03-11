class AddSprintGoalIdToQuestionsSprintGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions_sprint_goals, :sprint_goal, null: false, foreign_key: true
  end
end
