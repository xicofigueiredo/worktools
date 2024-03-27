class RenameMeetingsToMeetingSlotsAndUpdateFields < ActiveRecord::Migration[7.0]
  def change
    rename_table :meetings, :meeting_slots
    add_column :meeting_slots, :date, :date
    remove_column :meeting_slots, :day_of_week
    remove_column :meeting_slots, :meeting_time
  end
end
