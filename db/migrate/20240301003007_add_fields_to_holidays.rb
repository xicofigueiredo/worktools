class AddFieldsToHolidays < ActiveRecord::Migration[7.0]
  def change
    add_column :holidays, :name, :string
    add_column :holidays, :bga, :boolean
  end
end
