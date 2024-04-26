class ModifyHolidaysTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :holidays, :date, :date
    add_column :holidays, :country, :string
  end
end
