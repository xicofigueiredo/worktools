class CreateLwsTimelines < ActiveRecord::Migration[7.0]
  def change
    create_table :lws_timelines do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :year
      t.integer :balance
      t.float :blocks_per_day

      t.timestamps
    end
  end
end
