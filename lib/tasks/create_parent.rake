require 'csv'

namespace :user do
  desc "Create parent accounts in bulk from a CSV file"
  task create_parents: :environment do
    file_path = 'lib/tasks/parents.csv'  # Adjust the path as necessary

    CSV.foreach(file_path, headers: true) do |row|
      parent_email = row['parent_email']
      parent_password = row['password']
      kids_emails = row.to_h.values[2..-1].compact  # Gets all kid emails and ignores empty values

      parent = User.create!(
        email: parent_email,
        password: parent_password,
        password_confirmation: parent_password,
        confirmed_at: Time.now,  # Automatically confirm the account
        role: 'Parent',
        kids: []
      )

      kids_ids = User.where(email: kids_emails).pluck(:id)
      parent.kids = kids_ids  # Assign kids' IDs directly if the model supports array storage

      if parent.save
        puts "Parent account for #{parent_email} created successfully with #{kids_ids.size} kids linked."
      else
        puts "Failed to create parent account for #{parent_email}: #{parent.errors.full_messages.join(', ')}"
      end
    end
  end
end
