class AddContactEmailsToHubs < ActiveRecord::Migration[7.0]
  def change
    add_column :hubs, :hub_email, :string
    add_column :hubs, :school_contact_emails, :string, array: true, default: []
  end
end
