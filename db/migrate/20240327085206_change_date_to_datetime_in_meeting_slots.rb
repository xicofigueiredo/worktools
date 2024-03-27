class ChangeDateToDatetimeInMeetingSlots < ActiveRecord::Migration[7.0]
  def change
    remove_column :meeting_slots, :date, :date
    add_column :meeting_slots, :meeting_datetime, :datetime
  end
end
