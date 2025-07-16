class CreateExamFinances < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_finances do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_cost

      t.timestamps
    end
  end
end
