require 'csv'

namespace :db do
  desc "Collect all emails from a CSV file and output sorted IDs and emails"
  task collect_sorted_ids_and_emails: :environment do
    file_path = 'lib/tasks/admissions_list.csv'
    missing_parents = []
    missing_kids = []
    # Simple approach: try CSV.foreach with different encodings directly
    encodings_to_try = ['UTF-8', 'ISO-8859-1', 'Windows-1252']

    successful = false

    encodings_to_try.each do |encoding|
      begin
        puts "Trying CSV.foreach with encoding: #{encoding}"

        CSV.foreach(file_path, headers: true, encoding: "#{encoding}:UTF-8") do |row|
          next if row.nil? || row['Status'] != 'Active'

          # Get email columns (handle nil values)
          kid_email = row['InstitutionalEmail']&.strip&.downcase
          parent1_email = row['Parent 1 - Email (6)']&.strip&.downcase
          parent2_email = row['Parent 2 - Email (6)']&.strip&.downcase

          # Skip if emails are missing or invalid
          next if kid_email.nil? || kid_email.empty? || kid_email == 'n/a'

          # Check if users exist in database
          kid = User.find_by(email: kid_email) if kid_email.present?
          parent1 = User.find_by(email: parent1_email) if parent1_email.present? && parent1_email != 'n/a'
          parent2 = User.find_by(email: parent2_email) if parent2_email.present? && parent2_email != 'n/a'

          # Report missing users
          if parent1_email.present? && parent1_email != 'n/a' && !parent1
            missing_parents << [parent1_email, kid_email]
          end

          if parent2_email.present? && parent2_email != 'n/a' && !parent2
            missing_parents << [parent2_email, kid_email]
          end

          unless kid
            missing_kids << kid_email
          end

        end

        missing_parents.each do |parent|
          puts "Parent email #{parent[0]} not found, kid email #{parent[1]}"
        end

        missing_kids.each do |kid|
          puts "Kid email #{kid} not found"
        end
        successful = true
        break

      rescue => e
        puts "❌ Failed with #{encoding}: #{e.message}"
        next
      end
    end

    unless successful
      puts "❌ Could not process CSV with any encoding"
    end
  end
end
