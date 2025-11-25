class AddCanTeachPtPlusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :can_teach_pt_plus, :boolean, default: false
  end
end
