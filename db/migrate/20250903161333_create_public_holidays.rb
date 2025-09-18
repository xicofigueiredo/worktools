class CreatePublicHolidays < ActiveRecord::Migration[7.0]
  def change
    create_table :public_holidays do |t|
      t.string :country
      t.references :hub, foreign_key: true, null: true
      t.date :date, null: false
      t.string :name, null: false
      t.boolean :recurring, null: false, default: false

      t.timestamps
    end

    add_index :public_holidays, :date
    add_index :public_holidays, [:country, :date]
    add_index :public_holidays, [:hub_id, :date]
  end
end
