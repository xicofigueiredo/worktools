class AllowNullForQuestionsSprintGoalIdInAnswers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :answers, :questions_sprint_goal_id, true
  end
end
