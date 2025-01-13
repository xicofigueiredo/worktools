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
          password: password,
          password_confirmation: password,
          confirmed_at: Time.now,
          role: 'Parent',
          kids: kid ? [kid.id] : []
        )
        lcs = kid.hubs.first.users.where(role: 'lc')
        ## only lcs with less than 3 hubs
        lcs = lcs.select { |lc| lc.hubs.count < 3 }
        parent.save!
        puts "Parent account for #{email} created successfully."
        UserMailer.welcome_parent(parent, password, lcs).deliver_now
      else
        puts "#{parent.email}  already exists."
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
      unless row['Institutional Email'].nil? || row['Guardian 1'].nil? || row['Email 1'].nil? || row['Password'].nil?
        parent_name = row['Guardian 1'].strip.capitalize
        parent1_email = row['Guardian 1 email'].strip.downcase
        parent1_password = row['Password'].strip
        kid_email = row['Institutional Email'].strip.downcase

        # Create or update the first parent
        create_parent_method.call(parent_name, parent1_email, parent1_password, kid_email)
      end

      # Create or update the second parent if present
      unless row['Email'].nil? || row['Guardian 3'].nil? || row['Email 3'].nil? || row['Password'].nil?
        parent2_name = row['Guardian 3'].strip.capitalize
        parent2_email = row['Guardian 3 email'].strip.downcase
        parent2_password = row['Password'].strip
        create_parent_method.call(parent2_name, parent2_email, parent2_password, kid_email)
      end
    end
  end
end
