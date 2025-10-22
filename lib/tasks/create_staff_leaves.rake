namespace :db do
  desc "Create staff leaves from CSV. (headers: Name,Country,Location,Employee Email,Start Date,End Date,Total days)"
  task create_staff_leaves: :environment do
    require 'csv'
    require 'securerandom'
    require 'json'

    def parse_date_from_string(value)
      return value if value.is_a?(Date)
      return nil if value.nil?

      str = value.to_s.strip
      return nil if str == ''

      if str =~ /\A\d+\z/
        begin
          return Date.new(1899,12,30) + str.to_i
        rescue
          # fall through
        end
      end

      formats = ['%m/%d/%Y', '%m/%d/%y', '%m-%d-%Y', '%Y-%m-%d', '%d/%m/%Y']
      formats.each do |fmt|
        begin
          return Date.strptime(str, fmt)
        rescue ArgumentError
          # next
        end
      end

      begin
        return Date.parse(str)
      rescue ArgumentError
        return nil
      end
    end

    # Print-only logger (no files)
    def log(level, message)
      time = defined?(Time) && Time.respond_to?(:current) ? Time.current.iso8601 : Time.now.iso8601
      puts "[#{time}] #{level.to_s.upcase}: #{message}"
    end

    csv_path = 'lib/tasks/staff_leaves.csv'

    unless File.exist?(csv_path)
      puts "CSV not found at #{csv_path}"
      return
    end

    processed = 0
    succeeded = 0
    fallback_used = 0
    failed = 0

    CSV.foreach(csv_path, headers: true, encoding: 'bom|utf-8').with_index(2) do |row, lineno|
      processed += 1
      begin
        email = (row['Employee Email'] || row['employee email'] || row['employee_email']).to_s.strip
        start_s = (row['Start Date'] || row['start date'] || row['start_date']).to_s.strip
        end_s   = (row['End Date']   || row['end date']   || row['end_date']).to_s.strip
        total_days_raw = (row['Total days'] || row['Total Days'] || row['total days'] || row['total_days']).to_s.strip

        if email.blank?
          msg = "Missing Employee Email"
          log(:warn, "Line #{lineno}: #{msg}")
          puts({ type: 'failure', line: lineno, employee_email: email, reason: msg, row: row.to_h }.to_json)
          failed += 1
          next
        end

        # find or create user (minimal fields)
        user = User.find_by(email: email.downcase)
        if user.nil?
          password = SecureRandom.hex(8)
          user = User.create!(
            email: email.downcase,
            password: password,
            full_name: email.split('@').first,
            confirmed_at: (defined?(Time) && Time.respond_to?(:current) ? Time.current : Time.now)
          )
          log(:info, "Line #{lineno}: created user id=#{user.id} for email #{email}")
        end

        # parse dates
        begin
          start_date = parse_date_from_string(start_s)
          end_date   = parse_date_from_string(end_s)
        rescue => _e
          msg = "Invalid dates (Start: #{start_s} End: #{end_s})"
          log(:warn, "Line #{lineno}: #{msg}")
          puts({ type: 'failure', line: lineno, employee_email: email, reason: msg, row: row.to_h }.to_json)
          failed += 1
          next
        end

        total_days = (total_days_raw.to_f).round.to_i

        attrs = {
          leave_type: 'holiday',
          user: user,
          start_date: start_date,
          end_date: end_date,
          total_days: total_days,
          exception_requested: true,
          exception_reason: 'Old Request',
          status: 'approved'
        }

        begin
          sl = StaffLeave.create!(attrs)
          succeeded += 1
          log(:info, "Line #{lineno}: created StaffLeave id=#{sl.id} for user_id=#{user.id} (safe path)")
        rescue ActiveRecord::RecordInvalid => invalid_exc
          log(:warn, "Line #{lineno}: create! failed: #{invalid_exc.record.errors.full_messages.join('; ')} - attempting fallback save(validate: false)")
          ActiveRecord::Base.transaction do
            years = []
            years << start_date.year if start_date
            years << end_date.year if end_date && end_date.year != start_date.year
            years.uniq.each do |y|
              StaffLeaveEntitlement.find_or_create_by!(user: user, year: y)
            end

            sl = StaffLeave.new(attrs)
            sl.total_days = total_days
            sl.save!(validate: false)
            log(:info, "Line #{lineno}: fallback created StaffLeave id=#{sl.id} for user_id=#{user.id}")

            begin
              sl.send(:deduct_entitlement_days) if sl.respond_to?(:deduct_entitlement_days, true)
            rescue => e
              log(:warn, "Line #{lineno}: error running deduct_entitlement_days: #{e.class}: #{e.message}")
            end

            begin
              if sl.confirmations.count == 0
                sl.send(:create_initial_confirmation) if sl.respond_to?(:create_initial_confirmation, true)
              end
            rescue => e
              log(:warn, "Line #{lineno}: error creating confirmations: #{e.class}: #{e.message}")
            end

            fallback_used += 1
          end
        end

      rescue => e
        log(:error, "Line #{lineno}: unexpected error #{e.class}: #{e.message}\n#{e.backtrace.first(6).join("\n")}")
        puts({ type: 'failure', line: lineno, employee_email: (email rescue ''), reason: "#{e.class}: #{e.message}", row: (row.respond_to?(:to_h) ? row.to_h : {}) }.to_json)
        failed += 1
      end
    end

    puts({ type: 'summary', processed: processed, succeeded: succeeded, fallback_used: fallback_used, failed: failed }.to_json)
  end
end
