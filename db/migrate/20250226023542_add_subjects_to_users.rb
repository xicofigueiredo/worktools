class AddSubjectsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subjects, :integer, array: true, default: [], using: 'gin'
  end
end
