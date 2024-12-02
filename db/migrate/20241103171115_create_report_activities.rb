class CreateReportActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :report_activities do |t|
      t.references :report, null: false, foreign_key: true
      t.string :activity
      t.string :goal
      t.text :reflection

      t.timestamps
    end
  end
end
