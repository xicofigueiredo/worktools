class CreateExamEnrollDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_enroll_documents do |t|
      t.references :exam_enroll, null: false, foreign_key: true
      t.string :file_name
      t.string :file_type
      t.string :file_path
      t.text :description

      t.timestamps
    end
  end
end
