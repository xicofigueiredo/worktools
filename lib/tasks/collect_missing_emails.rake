require 'csv'

namespace :db do
  desc "Collect all emails from a CSV file and output sorted IDs and emails"
  task collect_sorted_ids_and_emails: :environment do
    file_path = 'lib/tasks/checkemails.csv' # Update this path if necessary

    found_users = []
    missing_emails = []

    # Process each row in the CSV
    CSV.foreach(file_path, headers: false) do |row|
      next if row[0].blank? # Ensure the email exists in the row

      email = row[0].strip.downcase # Strip whitespace and normalize case

      # Check if the email exists in the database
      user = User.find_by(email: email)
      if user
        found_users << { id: user.id, email: user.email } # Collect user details
      else
        missing_emails << email
      end
    end

    # Sort found users by ID size (number of digits) and then email alphabetically
    sorted_users = found_users.sort_by { |user| [user[:id].to_s.length, user[:email]] }

    # Output the sorted IDs and emails
    if sorted_users.any?
      puts "The following user IDs and emails were found in the database (sorted by ID size and email):"
      sorted_users.each do |user|
        puts "ID: #{user[:id]}, Email: #{user[:email]}"
      end
    else
      puts "No emails from the CSV were found in the database."
    end

    # Output the missing emails
    if missing_emails.any?
      puts "The following emails do not exist in the database:"
      missing_emails.each { |email| puts email }
    end
  end
end
