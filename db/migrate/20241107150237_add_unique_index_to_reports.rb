class AddUniqueIndexToReports < ActiveRecord::Migration[7.0]
  def change
    add_index :reports, [:user_id, :sprint_id], unique: true
  end
end
