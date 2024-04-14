class AddAbsenceToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :absence, :string
  end
end
