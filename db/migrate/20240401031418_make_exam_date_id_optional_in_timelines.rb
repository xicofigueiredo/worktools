class MakeExamDateIdOptionalInTimelines < ActiveRecord::Migration[7.0]
  def change
    change_column_null :timelines, :exam_date_id, true
  end
end
