class UpdateUserFields < ActiveRecord::Migration[7.0]
  def up
    # Add new fields
    add_column :users, :id_number, :string
    add_column :users, :gender, :string

    # Add the new boolean field
    add_column :users, :native_language_english, :boolean

    # Remove the old native_language column
    remove_column :users, :native_language
  end

  def down
    # Add back the old native_language column
    add_column :users, :native_language, :string

    # Remove the new fields
    remove_column :users, :native_language_english
    remove_column :users, :gender
    remove_column :users, :id_number
  end
end
