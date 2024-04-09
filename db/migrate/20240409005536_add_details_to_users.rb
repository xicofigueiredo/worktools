class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :level, :string
    add_column :users, :birthday, :date
    add_column :users, :nationality, :string
    add_column :users, :native_language, :string
    add_column :users, :profile_pic, :string
  end
end
