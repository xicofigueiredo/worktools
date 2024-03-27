class RemoveUserIdFromWeeklyMeetings < ActiveRecord::Migration[7.0]
  def change
    remove_column :weekly_meetings, :user_id
  end
end
