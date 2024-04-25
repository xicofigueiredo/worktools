class AddTimeZoneToHubs < ActiveRecord::Migration[7.0]
  def change
    add_column :hubs, :time_zone, :string, default: 'Europe/Lisbon'
  end
end
