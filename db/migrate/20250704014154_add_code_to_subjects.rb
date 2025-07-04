class AddCodeToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :code, :string
  end
end
