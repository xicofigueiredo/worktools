class AddUniqueIndexToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_index :attendances, [:user_id, :attendance_date], unique: true
  end
end
