class CreateWeeklyMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_meetings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.references :hub, null: false, foreign_key: true

      t.timestamps
    end
  end
end
