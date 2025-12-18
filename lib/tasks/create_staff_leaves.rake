namespace :db do
  desc "Import staff leaves from CSV (Format: mm/dd/yyyy). Handles carry-over days and entitlement deductions."
  task create_staff_leaves: :environment do
    require 'csv'
    require 'json'

    def log(level, message)
      time = defined?(Time) && Time.respond_to?(:current) ? Time.current.iso8601 : Time.now.iso8601
      puts "[#{time}] #{level.to_s.upcase}: #{message}"
    end

    csv_path = 'lib/tasks/staff_leaves_2.csv'

    unless File.exist?(csv_path)
      puts "Error: CSV not found at #{csv_path}"
      return
    end

    stats = { processed: 0, succeeded: 0, skipped: 0, failed: 0 }
    log(:info, "Starting import from #{csv_path}...")

    CSV.foreach(csv_path, headers: true, encoding: 'ISO-8859-1:utf-8').with_index(2) do |row, lineno|
      stats[:processed] += 1

      # 1. Extract and Clean Data
      email     = (row['Employee Email'] || row['Email']).to_s.strip.downcase
      start_s   = row['Start Date'].to_s.strip
      end_s     = row['End Date'].to_s.strip
      type_s    = (row['Type'] || row['Leave Type'] || 'holiday').to_s.strip.downcase
      total_raw = (row['Total days'] || row['Total Days']).to_s.strip
      prev_raw  = (row['Days from previous year'] || row['Days from Previous Year']).to_s.strip

      # 2. Validation
      if email.blank? || start_s.blank? || end_s.blank?
        log(:warn, "Line #{lineno}: Missing required fields. Skipping.")
        stats[:failed] += 1
        next
      end

      user = User.find_by(email: email)
      if user.nil?
        log(:warn, "Line #{lineno}: User '#{email}' not found. Skipping.")
        stats[:skipped] += 1
        next
      end

      begin
        start_date = Date.strptime(start_s, '%m/%d/%Y')
        end_date   = Date.strptime(end_s, '%m/%d/%Y')
      rescue ArgumentError
        log(:error, "Line #{lineno}: Invalid date format (Expected mm/dd/yyyy). Skipping.")
        stats[:failed] += 1
        next
      end

      # 3. Duplicate Check
      if StaffLeave.exists?(user: user, start_date: start_date, end_date: end_date)
        log(:info, "Line #{lineno}: Leave already exists for #{email}. Skipping.")
        stats[:skipped] += 1
        next
      end

      # 4. Prepare Attributes
      valid_types = StaffLeave::LEAVE_TYPES
      leave_type  = valid_types.include?(type_s) ? type_s : 'holiday'

      # Convert to integers, default to 0 if empty
      total_days     = total_raw.to_f.round.to_i
      days_from_prev = prev_raw.to_f.round.to_i

      # Ensure Entitlement records exist so the callback has a target
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
        status: 'approved',
        exception_requested: true, # Bypass advance notice and overlap rules for migration
        exception_reason: 'System Migration Import',
        notes: "Imported via CSV (Line #{lineno})"
      }

      # 5. Create Record
      begin
        # Attempt standard save to trigger 'deduct_entitlement_days' callback
        sl = StaffLeave.create!(attrs)
        stats[:succeeded] += 1
        log(:info, "Line #{lineno}: Created leave for #{email} (ID: #{sl.id})")
      rescue ActiveRecord::RecordInvalid => e
        log(:warn, "Line #{lineno}: Validation failed (#{e.message}). Attempting forced save...")

        sl = StaffLeave.new(attrs)
        # If total_days was 0 in CSV, let the model calculate it
        sl.calculate_total_days if sl.total_days.to_i == 0

        if sl.save(validate: false)
          # Manually trigger entitlement deduction if validation was skipped
          sl.send(:deduct_entitlement_days)
          stats[:succeeded] += 1
          log(:info, "Line #{lineno}: Created leave via Forced Path (ID: #{sl.id})")
        else
          log(:error, "Line #{lineno}: Save failed completely.")
          stats[:failed] += 1
        end
      rescue => e
        log(:error, "Line #{lineno}: Unexpected error: #{e.message}")
        stats[:failed] += 1
      end
    end

    puts stats.to_json
  end
end
