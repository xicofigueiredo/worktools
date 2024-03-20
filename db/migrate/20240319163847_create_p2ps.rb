class CreateP2ps < ActiveRecord::Migration[7.0]
  def change
    create_table :p2ps do |t|
      t.integer :rating
      t.text :why
      t.text :improve
      t.references :kda, null: false, foreign_key: true

      t.timestamps
    end
  end
end
