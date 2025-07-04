class AddBoardToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :board, :string
  end
end
