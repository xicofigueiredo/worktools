class AddExamSeasonToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :exam_season, :string
  end
end
