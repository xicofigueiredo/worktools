class ChangePersonalizedExamDateToString < ActiveRecord::Migration[7.0]
  def up
    change_column :exam_enrolls, :personalized_exam_date, :string
  end

  def down
    change_column :exam_enrolls, :personalized_exam_date, :date
  end
end
