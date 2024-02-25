class AddDateToHolidays < ActiveRecord::Migration[7.0]
  def change
    add_column :holidays, :date, :date
  end
end
