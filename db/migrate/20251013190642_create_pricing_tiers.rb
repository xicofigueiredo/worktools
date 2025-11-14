class CreatePricingTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :pricing_tiers do |t|
      t.string :model, null: false
      t.string :country, null: false
      t.string :currency, null: false
      t.string :hub_type, null: false
      t.string :specific_hub
      t.string :curriculum

      t.integer :admission_fee
      t.integer :monthly_fee
      t.integer :renewal_fee

      t.string :invoice_recipient
      t.text :notes

      t.timestamps
    end

    add_index :pricing_tiers, [:model, :country, :hub_type]
    add_index :pricing_tiers, :curriculum
    add_index :pricing_tiers, [:model, :country, :currency, :hub_type, :specific_hub, :curriculum],
              name: 'index_pricing_tiers_on_unique_combination'
  end
end
