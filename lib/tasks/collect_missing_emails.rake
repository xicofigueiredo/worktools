require 'csv'

namespace :db do
  desc "Collect all institutional emails from a CSV file that don't exist in the database"
  task collect_missing_emails: :environment do
    file_path = 'lib/tasks/parents.csv' # Adjust the path as necessary

    missing_emails = []

    # Process each row in the CSV
    CSV.foreach(file_path, headers: true) do |row|
      next if row['Institutional Email'].blank?

      kid_email = row['Institutional Email'].strip.downcase

      # Check if the email exists in the database
      unless User.exists?(email: kid_email)
        missing_emails << kid_email
      end
    end

    # Output the missing emails
    if missing_emails.any?
      puts "The following institutional emails do not exist in the database:"
      missing_emails.each { |email| puts email }
    else
      puts "All institutional emails from the CSV exist in the database."
    end
  end
end
