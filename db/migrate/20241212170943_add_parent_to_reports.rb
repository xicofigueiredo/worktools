class AddParentToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :parent, :boolean, degault: false
  end
end
