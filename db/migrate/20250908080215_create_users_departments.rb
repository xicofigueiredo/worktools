class CreateUsersDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :users_departments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end

    add_index :users_departments, [:user_id, :department_id], unique: true
  end
end
