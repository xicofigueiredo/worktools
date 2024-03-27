class AddDayOfWeekToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :day_of_week, :string
  end
end
