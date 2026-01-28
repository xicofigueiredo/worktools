class UpdatePricingTiersStructure < ActiveRecord::Migration[7.0]
  def up
    add_reference :pricing_tiers, :hub, foreign_key: true, null: true
    add_column :pricing_tiers, :academic_year, :integer, default: "2025"

    change_column :pricing_tiers, :monthly_fee, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :pricing_tiers, :admission_fee, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :pricing_tiers, :renewal_fee, :decimal, precision: 10, scale: 2, default: 0.0
  end

  def down
    remove_reference :pricing_tiers, :hub
    remove_column :pricing_tiers, :academic_year

    change_column :pricing_tiers, :monthly_fee, :integer
    change_column :pricing_tiers, :admission_fee, :integer
    change_column :pricing_tiers, :renewal_fee, :integer
  end
end
