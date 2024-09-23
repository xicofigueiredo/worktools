class AddKidsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :kids, :integer, array: true, default: []
  end
end
