class RenameValidToValidatedInCscActivities < ActiveRecord::Migration[7.0]
  def change
    rename_column :csc_activities, :valid, :validated
  end
end



