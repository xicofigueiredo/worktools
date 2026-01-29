class AddPartnerFieldsToCscActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :csc_activities, :partner_person, :string
    add_column :csc_activities, :partner_contact, :string
    add_column :csc_activities, :confirmation_participation, :string
  end
end
