class AddActivityDetailsToCscActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :csc_activities, :activity_name, :string
    add_column :csc_activities, :activity_type, :string
    add_column :csc_activities, :start_date, :date
    add_column :csc_activities, :end_date, :date
  end
end
