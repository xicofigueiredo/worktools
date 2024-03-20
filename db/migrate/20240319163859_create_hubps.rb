class CreateHubps < ActiveRecord::Migration[7.0]
  def change
    create_table :hubps do |t|
      t.integer :rating
      t.text :why
      t.text :improve
      t.references :kda, null: false, foreign_key: true

      t.timestamps
    end
  end
end
