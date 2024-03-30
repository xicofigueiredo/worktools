class ModifyMeetingSlotsStructure < ActiveRecord::Migration[7.0]
  def change
    # Uncomment the line below if the meeting_slots table exists and you want to remove it
    drop_table :meeting_slots, if_exists: true

    # Create a table for each weekday
    %w[monday tuesday wednesday thursday friday].each do |day|
      create_table "#{day}_slots" do |t|
        t.references :weekly_meeting, null: false, foreign_key: { to_table: :weekly_meetings }
        t.string :time_slot
        t.references :lc, foreign_key: { to_table: :users }
        t.references :learner, foreign_key: { to_table: :users }
        t.timestamps
      end
    end
  end
end
