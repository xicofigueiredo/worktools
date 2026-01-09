class AddOutlookEventIdToHubVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :hub_visits, :outlook_event_id, :string
  end
end
