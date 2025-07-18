class AddCurrencyToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :currency, :string, default: 'EUR'
  end
end
