class AddMustChangePasswordToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :changed_password, :boolean, default: false

    # Add a default value of `true` for existing users in the database
    User.update_all(changed_password: true)
  end
end
