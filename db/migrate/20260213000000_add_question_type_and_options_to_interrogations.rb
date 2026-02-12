class AddQuestionTypeAndOptionsToInterrogations < ActiveRecord::Migration[7.0]
  def change
    add_column :interrogations, :question_type, :string
    add_column :interrogations, :options, :text
  end
end
