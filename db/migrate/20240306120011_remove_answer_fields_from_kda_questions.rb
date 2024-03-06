class RemoveAnswerFieldsFromKdaQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :kdas_questions, :sdl, :string
    remove_column :kdas_questions, :ini, :string
    remove_column :kdas_questions, :mot, :string
    remove_column :kdas_questions, :p2p, :string
    remove_column :kdas_questions, :hubp, :string
    remove_column :kdas_questions, :question_value, :string
  end
end
