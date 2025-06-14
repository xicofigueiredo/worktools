class CreateMoodleTimelines < ActiveRecord::Migration[7.0]
  def change
    create_table :moodle_timelines do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :total_time
      t.integer :balance
      t.integer :expected_progress
      t.integer :progress
      t.references :exam_date, foreign_key: true
      t.integer :category, null: false
      t.datetime :mock50
      t.datetime :mock100
      t.string :personalized_name
      t.string :color
      t.boolean :hidden
      t.integer :difference
      t.integer :course_id

      t.timestamps
    end
  end
end
