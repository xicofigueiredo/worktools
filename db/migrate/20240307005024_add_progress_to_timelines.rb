class AddProgressToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :progress, :integer
  end
end
