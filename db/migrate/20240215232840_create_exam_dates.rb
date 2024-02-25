class CreateExamDates < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_dates do |t|
      t.references :subject, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
