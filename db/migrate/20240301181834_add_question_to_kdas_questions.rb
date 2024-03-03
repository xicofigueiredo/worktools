class AddQuestionToKdasQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :kdas_questions, :question, null: false, foreign_key: true
  end
end
