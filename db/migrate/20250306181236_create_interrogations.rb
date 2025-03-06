class CreateInterrogations < ActiveRecord::Migration[7.0]
  def change
    create_table :interrogations do |t|
      t.string :content
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
