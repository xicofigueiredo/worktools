class AddQuestionsSprintGoalIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :questions_sprint_goal, null: false, foreign_key: true
  end
end
