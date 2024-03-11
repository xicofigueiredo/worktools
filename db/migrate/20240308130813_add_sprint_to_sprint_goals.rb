class AddSprintToSprintGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :sprint_goals, :sprint, null: false, foreign_key: true
  end
end
