class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :user, foreign_key: true
      t.date :attendance_date
      t.time :start_time
      t.time :end_time
      t.boolean :present
      t.text :comments
      t.timestamps
    end
  end
end
