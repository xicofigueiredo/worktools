class AddLastUpdateCheckToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :last_update_check, :date
  end
end
