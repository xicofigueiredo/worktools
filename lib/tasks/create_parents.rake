require 'csv'

namespace :db do
  desc "Create or update parent accounts in bulk from a CSV file"
  task create_parents: :environment do
    file_path = 'lib/tasks/parentss.csv' # Adjust the path as necessary





    #NEED TO FILTER THE KIDS THAT ARE NOT ACTIVE OR GRADUATED








    # Method to create or update a parent account
    create_parent_method = lambda do |name, email, password, kid_email|
      return if email.blank? || password.blank? || kid_email.blank?


      # Find or create the parent
      parent = User.find_or_initialize_by(email: email.strip.downcase)
      kid = User.find_by(email: kid_email.strip.downcase)

      if kid && kid.deactivate?
        puts "Kid with email #{kid_email} is deactivated, skipping parent creation for #{email}."
        return
      elsif kid.nil?
        puts "Kid with email #{kid_email} not found, skipping parent creation for #{email}."
        return
      end

      if parent.new_record?
        if kid.present?
          parent.assign_attributes(
            full_name: name,
            password: password,
            password_confirmation: password,
            confirmed_at: Time.now,
            role: 'Parent',
            kids: [kid.id]
          )

          # Find LC with less than 3 hubs linked to the kid's hub
          lcs = kid.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc').select { |lc| lc.hubs.count < 3 }

          if parent.save
            puts "Parent account for #{email} created successfully."
            UserMailer.welcome_parent(parent, password, lcs).deliver_now
          else
            puts "Failed to save new parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
          end
        else
          puts "Kid with email #{kid_email} not found, skipping parent creation for #{email}."
        end
      else
        # Update existing parent
        parent.kids << kid.id if kid && !parent.kids.include?(kid.id)
        if parent.save
          kid_emails = parent.kids.map { |kid_id| User.find(kid_id).email }
          puts "Parent account for #{email} updated. Kids linked: #{kid_emails.join(', ')}"
        else
          puts "Failed to update parent account for #{email}: #{parent.errors.full_messages.join(', ')}"
        end
      end
    end

    # Process each row in the CSV
    CSV.foreach(file_path, headers: true) do |row|
      next if row['InstitutionalEmail'].blank? || row['Parent 1 - Full Name (Section 6)'].blank? || row['Parent 1 - Email (6)'].blank?

      kid_email = row['InstitutionalEmail'].strip.downcase

      # Create or update the first parent
      parent1_name = row['Parent 1 - Full Name (Section 6)'].strip
      parent1_email = row['Parent 1 - Email (6)'].strip.downcase
      parent1_password = SecureRandom.hex(8)
      create_parent_method.call(parent1_name, parent1_email, parent1_password, kid_email)

      # Create or update the second parent if present
      if row['Parent 2 - Full Name (Section 6)'].present? && row['Parent 2 - Email (6)'].present?
        parent2_name = row['Parent 2 - Full Name (Section 6)'].strip
        parent2_email = row['Parent 2 - Email (6)'].strip.downcase
        parent2_password = SecureRandom.hex(8)
        create_parent_method.call(parent2_name, parent2_email, parent2_password, kid_email)
      end
    end
  end
end
