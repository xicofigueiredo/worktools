class CreateConsentActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :consent_activities do |t|
      t.references :consent, null: false, foreign_key: true

      t.string :day
      t.string :activity_location
      t.string :meeting
      t.string :pick_up
      t.string :location
      t.string :transport
      t.string :bring_along

      t.timestamps
    end

    add_index :consent_activities, :day
  end
end
