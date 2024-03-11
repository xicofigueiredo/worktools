class AddQuestionIdToQuestionsSprintGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions_sprint_goals, :question, null: true, foreign_key: true
  end
end
