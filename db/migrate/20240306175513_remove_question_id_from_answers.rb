class RemoveQuestionIdFromAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :question_id, :bigint
  end
end
