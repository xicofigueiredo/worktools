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
      name_str = row['Name'].to_s.strip

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

      # 2. Find or Initialize User
      user = User.find_or_initialize_by(email: email)

      # Always update the name if present in CSV
      user.full_name = name_str if name_str.present?

      # Only set these if it's a brand new user
      if user.new_record?
        user.password = "123456"
        user.password_confirmation = "123456"
        user.confirmed_at = Time.current
        user.role = 'staff'
        puts "Line #{lineno}: Creating new user for #{email}"
      end

      unless user.save
        puts "Line #{lineno}: Error saving user #{email} - #{user.errors.full_messages.join(', ')}"
        next
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
