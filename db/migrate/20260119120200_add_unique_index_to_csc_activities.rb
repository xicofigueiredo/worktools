class AddUniqueIndexToCscActivities < ActiveRecord::Migration[7.0]
  def change
    add_index :csc_activities, [:activitable_type, :activitable_id], unique: true, name: 'index_csc_activities_on_activitable_unique'
  end
end

