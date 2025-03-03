require 'csv'

namespace :db do
  desc "Create cm accounts in bulk from a CSV file"
  task create_cms: :environment do
    file_path = 'lib/tasks/cms.csv' # Adjust the path as necessary

    # Method to create or update a CM account
    create_cm_method = lambda do |name, email, password, subjects_array|
      return if email.blank? || password.blank? || subjects_array.blank?

      # Find or create the course manager
      cm = User.find_or_initialize_by(email: email.strip.downcase)

      cm.assign_attributes(
        full_name: name,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.now,
        role: 'Course Manager',
        subjects: subjects_array # Assign the properly formatted array of subject IDs
      )

      if cm.save
        UserMailer.welcome_cm(cm, password).deliver_now
        puts "Successfully created/updated CM: #{name} with subjects: #{subjects_array.join(', ')}"
      else
        puts "Failed to create/update CM: #{name}. Errors: #{cm.errors.full_messages.join(', ')}"
      end
    end

    # Process each row in the CSV
    CSV.foreach(file_path, headers: true) do |row|
      next if row['email'].blank? || row['name'].blank? || row['subjects'].blank?

      # Parse the subjects string into an array of integers
      subjects_array = row['subjects'].split(',').map(&:strip).map(&:to_i)

      name = row['name'].strip
      email = row['email'].strip.downcase
      password = SecureRandom.hex(8)

      create_cm_method.call(name, email, password, subjects_array)
    end

    puts "CM creation process completed!"
  end
end
