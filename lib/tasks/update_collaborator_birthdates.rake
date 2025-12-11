namespace :db do
  desc "Update collaborator birthdates from CSV"
  task update_collaborator_birthdates: :environment do
    require 'csv'

    csv_path = 'lib/tasks/collaborator_info.csv'

    unless File.exist?(csv_path)
      puts "Error: File not found at #{csv_path}"
      return
    end

    puts "Starting import..."

    CSV.foreach(csv_path, headers: true, encoding: 'ISO-8859-1:utf-8').with_index(2) do |row, lineno|
      email = row['BGA Email'].to_s.strip.downcase
      dob_str = row['Date of Birth'].to_s.strip

      if email.empty? || dob_str.empty?
        puts "Line #{lineno}: Missing email or date. Skipping."
        next
      end

      # 1. Parse Date (Strict mm/dd/yyyy)
      begin
        birthdate = Date.strptime(dob_str, '%m/%d/%Y')
      rescue ArgumentError
        puts "Line #{lineno}: Invalid date format '#{dob_str}' (Expected mm/dd/yyyy). Skipping."
        next
      end

      # 2. Find or Create User
      user = User.find_or_create_by(email: email) do |u|
        u.password = "123456"
        u.password_confirmation = "123456"
        u.full_name = email.split('@').first.titleize
        u.confirmed_at = Time.current
        u.role = 'staff'
        puts "Line #{lineno}: Created new user for #{email}"
      end

      # 3. Find or Create CollaboratorInfo & Update
      info = CollaboratorInfo.find_or_create_by(user: user)
      info.birthdate = birthdate

      if info.save
        puts "Line #{lineno}: Updated #{email} birthdate to #{birthdate}"
      else
        puts "Line #{lineno}: Error saving info - #{info.errors.full_messages.join(', ')}"
      end
    end

    puts "Import finished."
  end
end
