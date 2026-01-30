class ChangeValidatedToStatusInCscActivities < ActiveRecord::Migration[7.0]
  def up
    add_column :csc_activities, :status, :string, default: "needs_revision", null: false

    # Migrate existing data
    CscActivity.reset_column_information
    CscActivity.where(validated: true).update_all(status: "approved")
    CscActivity.where(validated: false).update_all(status: "needs_revision")

    remove_column :csc_activities, :validated
  end

  def down
    add_column :csc_activities, :validated, :boolean, default: false, null: false

    CscActivity.reset_column_information
    CscActivity.where(status: "approved").update_all(validated: true)
    CscActivity.where(status: ["needs_revision", "rejected"]).update_all(validated: false)

    remove_column :csc_activities, :status
  end
end
