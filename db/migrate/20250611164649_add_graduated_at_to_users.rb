class AddGraduatedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :graduated_at, :datetime
  end
end
