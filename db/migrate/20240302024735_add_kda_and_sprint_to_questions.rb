class AddKdaAndSprintToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :kda, :boolean
    add_column :questions, :sprint, :boolean
  end
end
