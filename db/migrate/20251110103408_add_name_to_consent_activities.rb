class AddNameToConsentActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :consent_activities, :name, :string
  end
end
