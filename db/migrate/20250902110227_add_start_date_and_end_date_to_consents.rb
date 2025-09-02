class AddStartDateAndEndDateToConsents < ActiveRecord::Migration[7.0]
  def change
    add_column :consents, :start_date, :date
    add_column :consents, :end_date, :date
  end
end
