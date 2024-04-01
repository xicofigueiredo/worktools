class AddSprintToWeeks < ActiveRecord::Migration[7.0]
  def change
    add_reference :weeks, :sprint, foreign_key: true
  end
end
