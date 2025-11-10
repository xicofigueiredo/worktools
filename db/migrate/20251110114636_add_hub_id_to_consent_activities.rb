class AddHubIdToConsentActivities < ActiveRecord::Migration[7.0]
  def change
    add_reference :consent_activities, :hub, null: false, foreign_key: true
  end
end
