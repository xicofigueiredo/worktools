class AddExamDateToTimelines < ActiveRecord::Migration[7.0]
  def change
    remove_column :timelines, :exam_season, :datatype
    add_reference :timelines, :exam_date, null: false, foreign_key: true
  end
end
