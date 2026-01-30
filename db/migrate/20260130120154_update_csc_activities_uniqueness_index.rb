class UpdateCscActivitiesUniquenessIndex < ActiveRecord::Migration[7.0]
  def change
    # Remove the old unique index that only uses activitable_type and activitable_id
    remove_index :csc_activities, name: "index_csc_activities_on_activitable_unique", if_exists: true

    # Add a new unique index that includes activity_type
    # This allows multiple CscActivities for the same activitable with different activity_types
    add_index :csc_activities, [:activitable_type, :activitable_id, :activity_type],
              unique: true,
              name: "index_csc_activities_on_activitable_unique"
  end
end
