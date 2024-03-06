class AddIdToKdasQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :kdas_questions, :id, :primary_key

  end
end
