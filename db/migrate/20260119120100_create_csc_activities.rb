class CreateCscActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :csc_activities do |t|
      t.references :csc_diploma, null: false, foreign_key: true
      t.references :activitable, polymorphic: true, null: false
      t.integer :hours
      t.integer :weight
      t.integer :credits
      t.string :rubric_score
      t.boolean :valid, default: false, null: false
      t.boolean :hidden, default: false, null: false

      t.timestamps
    end
  end
end
