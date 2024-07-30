class AddHiddenToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :hidden, :boolean, default: false
  end
end
