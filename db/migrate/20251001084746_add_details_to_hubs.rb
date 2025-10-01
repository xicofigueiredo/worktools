class AddDetailsToHubs < ActiveRecord::Migration[7.0]
  def change
    add_column :hubs, :address, :text
    add_column :hubs, :google_map_link, :text
    add_column :hubs, :city, :string
    add_column :hubs, :region, :string
    add_column :hubs, :type, :string
    add_column :hubs, :exam_center, :boolean, default: false, null: false
    add_column :hubs, :capacity, :integer
    add_column :hubs, :parents_whatsapp_group, :text

    add_index :hubs, :city
    add_index :hubs, :region
    add_index :hubs, :type
  end
end
