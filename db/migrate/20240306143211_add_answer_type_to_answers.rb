class AddAnswerTypeToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :answer_type, :string
  end
end
