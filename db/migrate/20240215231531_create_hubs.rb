class CreateHubs < ActiveRecord::Migration[7.0]
  def change
    create_table :hubs do |t|
      t.string :name
      t.string :country

      t.timestamps
    end
  end
end
