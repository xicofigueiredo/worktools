class CreateTimelineProgresses < ActiveRecord::Migration[7.0]
  def change
    create_table :timeline_progresses do |t|
      t.references :timeline, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.integer :progress

      t.timestamps
    end
  end
end
