namespace :db do
  desc "Create staff leaves from CSV (Format: mm/dd/yyyy). Headers: Employee Email, Start Date, End Date, Leave Type, Total Days, Days Previous Year"
  task create_staff_leaves: :environment do
    require 'csv'
    require 'json'

    # Print-only logger
    def log(level, message)
      time = defined?(Time) && Time.respond_to?(:current) ? Time.current.iso8601 : Time.now.iso8601
      puts "[#{time}] #{level.to_s.upcase}: #{message}"
    end

    csv_path = 'lib/tasks/staff_leaves.csv'

    unless File.exist?(csv_path)
      puts "Error: CSV not found at #{csv_path}"
      return
    end

    processed = 0
    succeeded = 0
    skipped = 0
    failed = 0

    log(:info, "Starting import from #{csv_path}...")

    # Using ISO-8859-1 to handle Excel encoding if needed, similar to previous tasks
    CSV.foreach(csv_path, headers: true, encoding: 'ISO-8859-1:utf-8').with_index(2) do |row, lineno|
      processed += 1

      # 1. Extract Data
      email = (row['Employee Email'] || row['Email']).to_s.strip.downcase
      start_s = row['Start Date'].to_s.strip
      end_s   = row['End Date'].to_s.strip
      type_s  = (row['Leave Type'] || 'holiday').to_s.strip.downcase
      total_days_raw = row['Total Days'].to_s.strip
      days_prev_raw  = (row['Days from Previous Year'] || row['days from previous year']).to_s.strip

      # 2. Basic Validation
      if email.blank? || start_s.blank? || end_s.blank?
        log(:warn, "Line #{lineno}: Missing required fields (Email, Start, or End). Skipping.")
        failed += 1
        next
      end

      # 3. Find User
      user = User.find_by(email: email)
      if user.nil?
        log(:warn, "Line #{lineno}: User not found for email '#{email}'. Skipping.")
        skipped += 1
        next
      end

      # 4. Parse Dates (Strict mm/dd/yyyy)
      begin
        start_date = Date.strptime(start_s, '%m/%d/%Y')
        end_date   = Date.strptime(end_s, '%m/%d/%Y')
      rescue ArgumentError
        log(:error, "Line #{lineno}: Invalid date format (Expected mm/dd/yyyy). Start: '#{start_s}', End: '#{end_s}'. Skipping.")
        failed += 1
        next
      end

      # 5. Check for Duplicates
      # We check if a leave already exists for this user with the same dates
      if StaffLeave.exists?(user: user, start_date: start_date, end_date: end_date)
        log(:info, "Line #{lineno}: Leave already exists for #{email} (#{start_date} to #{end_date}). Skipping.")
        skipped += 1
        next
      end

      # 6. Prepare Attributes
      # Normalize leave type (default to holiday if unknown or empty)
      valid_types = StaffLeave::LEAVE_TYPES
      leave_type = valid_types.include?(type_s) ? type_s : 'holiday'

      total_days = total_days_raw.to_f.round.to_i
      days_from_prev = days_prev_raw.to_f.round.to_i

      # Ensure Entitlements Exist for relevant years
      # This ensures the callback has a record to deduct from
      (start_date.year..end_date.year).each do |y|
        StaffLeaveEntitlement.find_or_create_by!(user: user, year: y)
      end

      attrs = {
        user: user,
        leave_type: leave_type,
        start_date: start_date,
        end_date: end_date,
        total_days: total_days,
        days_from_previous_year: days_from_prev,
        status: 'approved', # Imported leaves are usually pre-approved
        exception_requested: true, # Bypass soft warnings like 30-day notice
        exception_reason: 'Imported via System Migration',
        notes: "Imported from CSV (Line #{lineno})"
      }

      # 7. Create StaffLeave
      begin
        # Try standard creation first to run all validations
        sl = StaffLeave.create!(attrs)
        succeeded += 1
        log(:info, "Line #{lineno}: Created leave for #{email} (Safe Path). ID: #{sl.id}")

      rescue ActiveRecord::RecordInvalid => e
        # If validation fails (e.g. Blocked Period overlap, Advance Notice), force save
        # We rely on callbacks (deduct_entitlement_days) running even with validate: false
        log(:warn, "Line #{lineno}: Validation failed (#{e.record.errors.full_messages.join(', ')}). Attempting forced save...")

        begin
          sl = StaffLeave.new(attrs)
          # Manually calculate total days if it wasn't provided or calc failed
          sl.calculate_total_days if total_days == 0

          if sl.save(validate: false)
            succeeded += 1
            log(:info, "Line #{lineno}: Created leave for #{email} (Forced Path). ID: #{sl.id}")
          else
            log(:error, "Line #{lineno}: Forced save failed completely.")
            failed += 1
          end
        rescue => e2
          log(:error, "Line #{lineno}: Critical error during forced save: #{e2.message}")
          failed += 1
        end
      end

    end

    puts({ type: 'summary', processed: processed, succeeded: succeeded, skipped: skipped, failed: failed }.to_json)
  end
end
