class RenameWeightToExtraInCscActivities < ActiveRecord::Migration[7.0]
  def up
    # Reset existing values that are too large for the new precision
    execute "UPDATE csc_activities SET weight = NULL WHERE weight IS NOT NULL"
    rename_column :csc_activities, :weight, :extra
    change_column :csc_activities, :extra, :decimal, precision: 3, scale: 1
  end

  def down
    change_column :csc_activities, :extra, :integer
    rename_column :csc_activities, :extra, :weight
  end
end
