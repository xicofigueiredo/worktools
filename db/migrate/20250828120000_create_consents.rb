class CreateConsents < ActiveRecord::Migration[7.0]
  def change
    create_table :consents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sprint, null: true, foreign_key: true
      t.references :week, null: true, foreign_key: true

      t.string :hub
      t.date :date

      t.boolean :confirmation_under_18
      t.boolean :confirmation_over_18

      t.string :emergency_contact_name
      t.string :emergency_contact_relationship
      t.string :emergency_contact_contact
      t.string :emergency_contact_email

      t.string :family_doctor_name
      t.string :family_doctor_contact

      t.string :work_adress

      t.string :utente_number
      t.string :health_insurance_plan
      t.string :health_insurance_contact

      t.string :emergency_contact_name_1
      t.string :emergency_contact_contact_1
      t.string :emergency_contact_name_2
      t.string :emergency_contact_contact_2
      t.string :emergency_contact_name_3
      t.string :emergency_contact_contact_3
      t.string :emergency_contact_name_4
      t.string :emergency_contact_contact_4

      t.string :allergies
      t.string :diet
      t.string :limitations
      t.string :medication
      t.string :additional_info
      t.string :consent_approved_by

      t.timestamps
    end

    add_index :consents, [:user_id, :sprint_id]
    add_index :consents, [:user_id, :week_id]
  end
end
