class AddExtraJustificationToCscActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :csc_activities, :extra_justification, :string
  end
end
