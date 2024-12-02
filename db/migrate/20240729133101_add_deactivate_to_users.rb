class AddDeactivateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deactivate, :boolean, default: false
  end
end
