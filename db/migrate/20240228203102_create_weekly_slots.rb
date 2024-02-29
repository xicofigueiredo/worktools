class CreateWeeklySlots < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_slots do |t|
      t.references :weekly_goal, null: false, foreign_key: true
      t.integer :day_of_week
      t.integer :time_slot
      t.string :subject_name
      t.string :topic_name

      t.timestamps
    end
  end
end
