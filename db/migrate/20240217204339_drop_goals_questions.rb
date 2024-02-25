class DropGoalsQuestions < ActiveRecord::Migration[7.0]
  def change
    drop_table :goals_questions
  end
end
