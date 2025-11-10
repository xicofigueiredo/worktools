class RemoveConsentIdFromConsentActivities < ActiveRecord::Migration[7.0]
  def change
    remove_reference :consent_activities, :consent, null: false, foreign_key: true
    add_reference :consent_activities, :week, null: true, foreign_key: true
  end
end
