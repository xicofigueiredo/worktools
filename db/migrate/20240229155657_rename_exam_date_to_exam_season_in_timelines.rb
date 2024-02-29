class RenameExamDateToExamSeasonInTimelines < ActiveRecord::Migration[7.0]
  def change
    rename_column :timelines, :exam_date, :exam_season
    change_column :timelines, :exam_season, :string
  end
end
