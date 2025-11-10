class WidenGradePrecisionOnSubmissions < ActiveRecord::Migration[7.0]
  def change
    change_column :submissions, :grade, :decimal, precision: 5, scale: 2
  end
end
