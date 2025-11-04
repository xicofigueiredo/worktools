class RemoveCityFromHubs < ActiveRecord::Migration[7.0]
  def change
    remove_index :hubs, name: "index_hubs_on_city"
    remove_column :hubs, :city, :string
  end
end
