class DropTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :answers

    # Then drop 'kdas_questions' if it only depends on 'questions'
    drop_table :kdas_questions

    # Next, drop 'questions_sprint_goals' if it depends on 'sprint_goals' and 'questions'
    drop_table :questions_sprint_goals

    # Finally, drop 'questions', assuming no other dependencies
    drop_table :questions
  end
end
