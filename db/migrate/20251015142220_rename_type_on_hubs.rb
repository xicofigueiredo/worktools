class RenameTypeOnHubs < ActiveRecord::Migration[7.0]
  def change
    rename_column :hubs, :type, :hub_type
  end
end
