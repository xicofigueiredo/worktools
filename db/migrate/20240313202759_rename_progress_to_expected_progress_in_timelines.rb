class RenameProgressToExpectedProgressInTimelines < ActiveRecord::Migration[7.0]
  def change
    rename_column :timelines, :progress, :expected_progress
  end
end
