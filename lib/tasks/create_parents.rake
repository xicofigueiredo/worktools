require 'csv'

namespace :user do
  desc "Create parent accounts in bulk from a CSV file"
  task create_parents: :environment do
    file_path = 'lib/tasks/parents.csv'  # Adjust the path as necessary

    create_parent_method = lambda do |name, email, password, kids_emails|
      return if email.blank? || password.blank?
      return if User.exists?(email: email)
      parent = User.create!(
        full_name: name,
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.now,
        role: 'Parent',
        kids: []
      )

      if parent.persisted?
        kids_ids = User.where(email: kids_emails).pluck(:id)
        parent.kids += kids_ids

        if parent.save
          puts "Parent account for #{email} created successfully with #{kids_ids.size} kids linked."
          puts "Kids: #{kids_emails.join(', ')}"
        else
          puts "Failed to save parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
        end
      else
        puts "Failed to create parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
      end
    end

    CSV.foreach(file_path, headers: true) do |row|
      parent_name = row['Parent 1'].strip.capitalize
      parent1_email = row['Email 1'].strip.downcase
      parent1_password = row['Password'].strip
      kids_emails = [row['Email'].strip.downcase].compact
      create_parent_method.call(parent_name, parent1_email, parent1_password, kids_emails)

      unless row['Parent 2'].nil? || row['Email 2'].nil? || row['Password 2'].nil?
        parent2_name = row['Parent 2'].strip.capitalize
        parent2_email = row['Email 2'].strip.downcase
        parent2_password = row['Password 2'].strip
        create_parent_method.call(parent2_name, parent2_email, parent2_password, kids_emails)
      end
    end
  end
end
