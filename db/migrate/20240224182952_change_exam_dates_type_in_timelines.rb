class ChangeExamDatesTypeInTimelines < ActiveRecord::Migration[7.0]
  def change
    change_column :timelines, :exam_dates, 'date USING CAST(exam_dates AS date)'
    rename_column :timelines, :exam_dates, :exam_date
  end
end
