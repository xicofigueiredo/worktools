class AddSubjectToQuestionsSprintGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions_sprint_goals, :subject, null: false, foreign_key: true
  end
end
