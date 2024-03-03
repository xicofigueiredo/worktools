class AddFieldsAndRemoveForeignKeyToKdasAndKdasQuestions < ActiveRecord::Migration[7.0]
  def change
    # Add new columns to the 'kdas_questions' table
    add_column :kdas_questions, :sdl, :string
    add_column :kdas_questions, :ini, :string
    add_column :kdas_questions, :mot, :string
    add_column :kdas_questions, :p2p, :string
    add_column :kdas_questions, :hubp, :string
    add_column :kdas_questions, :question_value, :string

    # Remove the 'question_id' column
    remove_column :kdas_questions, :question_id
  end
end
