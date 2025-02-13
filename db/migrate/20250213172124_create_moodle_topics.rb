class CreateMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :moodle_topics do |t|
      t.references :timeline, null: false, foreign_key: true
      t.float :time, null: false
      t.string :name, null: false
      t.string :unit, null: false
      t.integer :order

      t.timestamps
    end
  end
end
