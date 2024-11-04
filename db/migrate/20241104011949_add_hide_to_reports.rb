class AddHideToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :hide, :boolean, default: true
  end
end
