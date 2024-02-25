class CreateUsersHubs < ActiveRecord::Migration[7.0]
  def change
    create_table :users_hubs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hub, null: false, foreign_key: true

      t.timestamps
    end
  end
end
