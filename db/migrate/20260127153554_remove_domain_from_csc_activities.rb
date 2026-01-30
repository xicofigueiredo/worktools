class RemoveDomainFromCscActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :csc_activities, :domain, :integer
  end
end
