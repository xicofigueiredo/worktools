require 'csv'
namespace :db do
  desc "Create users from CSV. CSV headers should include email, name, location (location decides role). Password will be lastname+role."
  task create_users: :environment do
    file_path = 'lib/tasks/users.csv'
    unless File.exist?(file_path)
      puts "CSV not found at #{file_path}. Place CSV there or change file_path."
      next
    end

    created_count = 0
    skipped_count = 0
    failed_count = 0

    # helper: simple sanitization for incoming fields
    sanitize = ->(v) { v.nil? ? '' : v.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '').scrub('') }

    # role mapping helper
    map_role = lambda do |location|
      loc = sanitize.call(location).strip.downcase
      puts "Location2: #{loc}"
      if loc == 'course manager'
        'Course Manager'
      elsif loc == 'central'
        'Staff'
      elsif loc == 'regional manager'
        'Regional Manager'
      else
        'Learning Coach'
      end
    end

    # extract last name helper
    lastname_from = lambda do |full_name|
      name = sanitize.call(full_name).strip
      return '' if name.empty?
      # if "Last, First" format, pick first token before comma as last name
      if name.include?(',')
        part = name.split(',').first.strip
        return part.split.last || part
      end
      # otherwise use last whitespace-separated token
      parts = name.split
      parts.last || parts.first
    end

    encodings_to_try = ['UTF-8', 'ISO-8859-1', 'Windows-1252']

    processed_ok = false
    encodings_to_try.each do |encoding|
      begin
        puts "Trying CSV.foreach with encoding: #{encoding}"
        CSV.foreach(file_path, headers: true, encoding: "#{encoding}:UTF-8") do |row|
          # Sanitize row values
          row_h = row.to_h.transform_values { |v| sanitize.call(v) }
          # header detection (flexible)
          email = (row_h['email'] || row_h['Email'] || row_h['employee email'] || row_h['Employee Email'] || row_h['employee_email']).to_s.strip
          full_name = (row_h['name'] || row_h['full_name'] || row_h['Name'] || row_h['Full Name']).to_s.strip
          location = (row_h['location'] || row_h['Location'] || row_h['hub'] || row_h['office']).to_s.strip

          if email.blank?
            puts "Skipping row with blank email (raw row: #{row_h})"
            failed_count += 1
            next
          end

          email = email.downcase

          user = User.find_or_initialize_by(email: email)

          if user.persisted?
            puts "User exists: #{email} (id=#{user.id}) — skipping creation"
            skipped_count += 1
            next
          end

          # new user: set attributes
          role = map_role.call(location)
          puts "Location: #{location}"
          lastname = lastname_from.call(full_name)
          # build predictable password: lastname + role (no spaces), fallback to random if lastname missing
          role_part = role.downcase.gsub(/\s+/, '')
          if lastname.empty?
            password = "#{SecureRandom.alphanumeric(8)}#{role_part}"
          else
            password = "#{lastname.downcase}#{role_part}"
          end

          user.full_name = full_name.presence || email.split('@').first
          user.password = password
          user.password_confirmation = password
          user.confirmed_at = Time.current
          user.role = role

          begin
            user.save!(validate: false)
            created_count += 1
            puts "Created user id=#{user.id} email=#{user.email} role=#{user.role} password=#{password}"
          rescue ActiveRecord::RecordInvalid => e
            failed_count += 1
            puts "Failed to create user for email=#{email}: #{e.record.errors.full_messages.join('; ')}"
          rescue => e
            failed_count += 1
            puts "Unexpected error creating user #{email}: #{e.class}: #{e.message}"
          end
        end

        processed_ok = true
        puts "✅ Successfully processed CSV with encoding #{encoding}"
        break
      rescue => e
        puts "⚠️  Failed with encoding #{encoding}: #{e.class}: #{e.message}"
        next
      end
    end

    unless processed_ok
      puts "❌ Could not process CSV with any encoding (tried #{encodings_to_try.join(', ')})"
      exit 1
    end

    puts "Done. created=#{created_count} skipped_existing=#{skipped_count} failed=#{failed_count}"
  end
end
