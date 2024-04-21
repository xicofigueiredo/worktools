class ChangeFollowUpActionTypeInNotes < ActiveRecord::Migration[7.0]
  def change
    change_column :notes, :follow_up_action, :text
  end
end
