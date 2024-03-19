class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.references :sprint_goal, null: false, foreign_key: true
      t.string :involved
      t.text :smartgoals
      t.text :difficulties
      t.text :plan

      t.timestamps
    end
  end
end
