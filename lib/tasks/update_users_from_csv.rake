require 'csv'

desc 'Update user fields from CSV file'
task update_users_from_csv: :environment do
  csv_file_path = Rails.root.join('lib', 'tasks', 'admissions_list.csv')

  unless File.exist?(csv_file_path)
    puts "CSV file not found at #{csv_file_path}"
    exit 1
  end

  updated_count = 0
  not_found_count = 0
  error_count = 0

  puts "Starting user update from CSV..."

  CSV.foreach(csv_file_path, headers: true, encoding: 'UTF-8') do |row|
    # Only use institutional email
    institutional_email = row['Institutional Email']

    next if institutional_email.blank? || row['Status'] != 'Active'

    # Find user by institutional email only
    user = User.find_by(email: institutional_email.strip.downcase)

    if user.nil?
      not_found_count += 1
      puts "User not found for email: #{institutional_email}"
      next
    end

    # Only update learners who are not deactivated
    unless user.role == 'learner' && user.deactivate != true
      puts "Skipping user #{user.email} - not an active learner"
      next
    end

    begin
      # Extract and update fields
      updates = {}

      # Birthday from Birthdate (5) - convert Excel date number to actual date
      birthdate_value = row['Birthdate (5)']
      if birthdate_value.present? && birthdate_value != 'N/A'
        begin
          # Handle Excel serial date number (days since 1900-01-01, but Excel incorrectly treats 1900 as leap year)
          if birthdate_value.match?(/^\d+$/)
            excel_date = birthdate_value.to_i
            # Excel epoch starts at 1900-01-01, but has a bug counting 1900 as leap year
            # So we need to subtract 2 days to get the correct date
            actual_date = Date.new(1899, 12, 30) + excel_date.days
            updates[:birthday] = actual_date
          else
            # Try to parse as regular date
            updates[:birthday] = Date.parse(birthdate_value)
          end
        rescue => e
          puts "Could not parse birthdate '#{birthdate_value}' for user #{user.email}: #{e.message}"
        end
      end

      # Gender from Learner's Gender (5)
      gender_value = row["Learner's Gender (5)"]
      if gender_value.present? && gender_value != 'N/A'
        updates[:gender] = gender_value.strip
      end

      # Native language English from English Proficiency (5)
      english_proficiency = row['English Proficiency (5)']
      if english_proficiency.present? && english_proficiency != 'N/A'
        case english_proficiency.strip.upcase
        when 'TRUE'
          updates[:native_language_english] = true
        when 'FALSE'
          updates[:native_language_english] = false
        else
          puts "Unknown English Proficiency value '#{english_proficiency}' for user #{user.email}"
        end
      end

      # ID Number from Learner's ID Information (5)
      id_info = row["Learner's ID Information (5)"]
      if id_info.present? && id_info != 'N/A'
        updates[:id_number] = id_info.strip
      end

      # Update user if we have any changes
      if updates.any?
        user.update!(updates)
        updated_count += 1
        puts "Updated user #{user.email} with: #{updates.keys.join(', ')}"
      else
        puts "No updates needed for user #{user.email}"
      end

    rescue => e
      error_count += 1
      puts "Error updating user #{user.email}: #{e.message}"
    end
  end

  puts "\n" + "="*50
  puts "Update completed!"
  puts "Users updated: #{updated_count}"
  puts "Users not found: #{not_found_count}"
  puts "Errors: #{error_count}"
  puts "="*50
end
