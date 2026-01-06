class CreateAiSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_summaries do |t|
      t.references :user, null: false, foreign_key: true
      t.text :summary
      t.text :key_points
      t.text :recommendations
      t.date :start_date
      t.date :end_date
      t.integer :notes_count, default: 0

      t.timestamps
    end

    add_index :ai_summaries, [:user_id, :start_date, :end_date]
  end
end
