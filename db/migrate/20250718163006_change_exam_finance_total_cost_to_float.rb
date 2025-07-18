class ChangeExamFinanceTotalCostToFloat < ActiveRecord::Migration[7.0]
  def up
    change_column :exam_finances, :total_cost, :float
  end

  def down
    change_column :exam_finances, :total_cost, :integer
  end
end
