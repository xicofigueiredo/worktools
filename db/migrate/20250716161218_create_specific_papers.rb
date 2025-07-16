class CreateSpecificPapers < ActiveRecord::Migration[7.0]
  def change
    create_table :specific_papers do |t|
      t.references :exam_finance, null: false, foreign_key: true
      t.references :exam_enroll, null: false, foreign_key: true
      t.string :name
      t.float :cost

      t.timestamps
    end
  end
end
