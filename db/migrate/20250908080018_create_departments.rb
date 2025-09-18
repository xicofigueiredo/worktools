class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.references :manager, foreign_key: { to_table: :users }
      t.references :superior, foreign_key: { to_table: :departments }
      t.timestamps
    end
  end
end
