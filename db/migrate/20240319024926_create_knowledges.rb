class CreateKnowledges < ActiveRecord::Migration[7.0]
  def change
    create_table :knowledges do |t|
      t.references :sprint_goal, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.text :difficulties
      t.text :plan

      t.timestamps
    end
  end
end
