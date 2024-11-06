class CreateReportKnowledges < ActiveRecord::Migration[7.0]
  def change
    create_table :report_knowledges do |t|
      t.references :report, null: false, foreign_key: true
      t.string :subject_name
      t.integer :progress
      t.integer :difference
      t.integer :grade
      t.string :exam_season

      t.timestamps
    end
  end
end
