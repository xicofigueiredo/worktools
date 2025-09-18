require 'csv'

namespace :db do
  desc "Create or update parent accounts in bulk from a CSV file"
  task create_parents: :environment do
    file_path = 'lib/tasks/admissions_list.csv' # Adjust the path as necessary
    kid_nil_counter = 0

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
        kid_nil_counter += 1
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
            kids: [kid.id],
            skip_domain_validation: true
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

    puts "Kid nil counter: #{kid_nil_counter}"

    # Try different encodings for CSV processing
    encodings_to_try = ['UTF-8', 'ISO-8859-1', 'Windows-1252']
    successful = false

    encodings_to_try.each do |encoding|
      begin
        puts "Trying CSV.foreach with encoding: #{encoding}"

        # Process each row in the CSV with encoding handling
        CSV.foreach(file_path, headers: true, encoding: "#{encoding}:UTF-8") do |row|
          next if row['InstitutionalEmail'].blank? || row['Parent 1 - Full Name (Section 6)'].blank? || row['Parent 1 - Email (6)'].blank? || row['Status'] != 'Active'

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

        puts "✅ Successfully processed CSV with #{encoding} encoding"
        successful = true
        break

      rescue => e
        puts "❌ Failed with #{encoding}: #{e.message}"
        next
      end
    end

    unless successful
      puts "❌ Could not process CSV with any encoding"
      exit 1
    end

    puts "Final kid nil counter: #{kid_nil_counter}"
  end
end
