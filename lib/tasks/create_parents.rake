require 'csv'

namespace :db do
  desc "Create or update parent accounts in bulk from a CSV file"
  task create_parents: :environment do
    file_path = 'lib/tasks/parents.csv' # Adjust the path as necessary

    create_parent_method = lambda do |name, email, password, kid_email|
      return if email.blank? || password.blank?

      # Find or create the parent
      parent = User.find_or_initialize_by(email: email.strip.downcase)

      kid = User.find_by(email: kid_email.strip.downcase)

      if parent.new_record? && kid.present?
        parent.assign_attributes(
          full_name: name,
          password:,
          password_confirmation: password,
          confirmed_at: Time.now,
          role: 'Parent',
          kids: kid ? [kid.id] : []
        )
        parent.save!
        puts "Parent account for #{email} created successfully."
        UserMailer.welcome_parent(parent, password).deliver_now
      else
        puts "Parent account for #{email} already exists, or kids not found."
      end

      if kid
        parent.kids << kid.id unless parent.kids.include?(kid.id)
      else
        puts "Kid with email #{kid_email} not found, skipping."
      end

      if parent.persisted?

        if parent.save
          kid_emails = parent.kids.map { |kid_id| User.find(kid_id).email }
          puts "Kids linked to parent #{email}: #{kid_emails.join(', ')}"
        else
          puts "Failed to save parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
        end
      else
        puts "Failed to create or find parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
      end
    end

    # Process each row in the CSV
    CSV.foreach(file_path, headers: true) do |row|
      unless row['Email'].nil? || row['Parent 2'].nil? || row['Email 2'].nil? || row['Password 2'].nil? || row['Parent 2'].zero? || row['Email 2'].zero? || row['Password 2'].zero?
        parent_name = row['Parent 1'].strip.capitalize
        parent1_email = row['Email 1'].strip.downcase
        parent1_password = row['Password'].strip
        kid_email = row['Email'].strip.downcase

        # Create or update the first parent
        create_parent_method.call(parent_name, parent1_email, parent1_password, kid_email)
      end

      # Create or update the second parent if present
      unless row['Email'].nil? || row['Parent 2'].nil? || row['Email 2'].nil? || row['Password 2'].nil? || row['Parent 2'].zero? || row['Email 2'].zero? || row['Password 2'].zero?
        parent2_name = row['Parent 2'].strip.capitalize
        parent2_email = row['Email 2'].strip.downcase
        parent2_password = row['Password 2'].strip
        create_parent_method.call(parent2_name, parent2_email, parent2_password, kid_email)
      end
    end
  end
end
