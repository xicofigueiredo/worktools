class AddLcIdsToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :lc_ids, :integer, array: true, default: []
  end
end
