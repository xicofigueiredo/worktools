class AddAnuladoToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :anulado, :boolean
  end
end
