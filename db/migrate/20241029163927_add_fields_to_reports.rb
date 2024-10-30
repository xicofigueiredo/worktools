class AddFieldsToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :sdl, :text
    add_column :reports, :ini, :text
    add_column :reports, :mot, :text
    add_column :reports, :p2p, :text
    add_column :reports, :hubp, :text
  end
end
