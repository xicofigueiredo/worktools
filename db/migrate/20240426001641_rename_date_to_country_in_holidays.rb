class RenameDateToCountryInHolidays < ActiveRecord::Migration[7.0]
  def change
    def change
      # Rename the column
      rename_column :holidays, :date, :country

      # Change the type of the new column
      change_column :holidays, :country, :string
    end
  end
end
