class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.references :subject, null: false, foreign_key: true
      t.boolean :done
      t.integer :time
      t.string :name
      t.integer :grade

      t.timestamps
    end
  end
end
