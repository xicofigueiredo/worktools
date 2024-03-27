class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings do |t|
      t.references :weekly_meeting, null: false, foreign_key: true
      t.references :lc, null: false, foreign_key: { to_table: :users }
      t.references :learner, null: false, foreign_key: { to_table: :users }
      t.string :meeting_time

      t.timestamps
    end
  end
end
