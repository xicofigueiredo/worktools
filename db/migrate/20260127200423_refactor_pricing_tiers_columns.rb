class RefactorPricingTiersColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :pricing_tiers, :academic_year, :year

    remove_column :pricing_tiers, :currency, :string
  end
end
