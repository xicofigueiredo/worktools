class AddPersonalizedExamDateToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :personalized_exam_date, :date
  end
end
