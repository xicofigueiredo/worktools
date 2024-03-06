class AddKdasQuestionIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :kdas_question, null: false, foreign_key: true
  end
end
