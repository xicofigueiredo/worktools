class CreateConsentStudyHubs < ActiveRecord::Migration[7.0]
  def change
    create_table :consent_study_hubs do |t|
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.references :week, null: false, foreign_key: true
      t.references :hub, null: false, foreign_key: true

      t.timestamps
    end
  end
end
