namespace :import do
  desc "Import or update staff users and department associations from CSV"
  task staff_users: :environment do
    require 'csv'

    csv_path = Rails.root.join('lib', 'tasks', 'employee_data.csv').to_s

    unless File.exist?(csv_path)
      abort "ERROR: CSV file not found at: #{csv_path}"
    end

    csv_text = File.read(csv_path, encoding: 'bom|utf-8')
    # Using comma as separator; update col_sep if your CSV uses semicolons
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')

    # Fetch roles from the User model enum
    available_roles = User.roles.keys

    csv.each_with_index do |row, idx|
      email = row['BGA Email']&.strip&.downcase
      full_name = row['Full Name']&.strip
      dept_name = row['Manager - Worktools - Department']&.strip

      if email.blank?
        puts "Skipping row #{idx + 1}: Missing 'BGA Email'"
        next
      end

      # 1. Find or Initialize the User
      user = User.find_by("LOWER(email) = ?", email)
      is_new_record = user.nil?

      if is_new_record
        puts "\n--- New User Found: #{email} ---"

        # Interactive Role Selection
        puts "Select a role for #{full_name}:"
        available_roles.each_with_index { |role, i| puts "  #{i + 1}) #{role}" }

        print "Enter selection (1-#{available_roles.size}): "
        selection = STDIN.gets.chomp.to_i
        selected_role = available_roles[selection - 1] || 'staff' # Default to staff if invalid

        user = User.new(
          email: email,
          role: selected_role,
          password: Devise.friendly_token[0, 20] # Random password for new users
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      end

      # 2. Update the Name
      user.full_name = full_name

      if user.save
        state = is_new_record ? "Created" : "Updated"
        puts "#{state} user: #{user.email} (Role: #{user.role}) (Name: #{user.full_name})"
      else
        puts "Error saving #{email}: #{user.errors.full_messages.join(', ')}"
        next
      end

      # 3. Associate with Department
      if dept_name.present?
        department = Department.find_by(name: dept_name)

        if department
          unless UsersDepartment.exists?(user: user, department: department)
            UsersDepartment.create!(user: user, department: department)
            puts "  -> Linked to Department: #{dept_name}"
          else
            puts "  -> Department link already exists."
          end
        else
          puts "  -> WARNING: Department '#{dept_name}' does not exist. Skipping association."
        end
      end
    end

    puts "\nProcessing complete."
  end
end
