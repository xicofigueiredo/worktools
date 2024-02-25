class CreateQuestionsSprintGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :questions_sprint_goals do |t|

      t.timestamps
    end
  end
end
