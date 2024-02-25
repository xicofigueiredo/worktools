class AddExamDatesToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :exam_dates, :text
  end
end
