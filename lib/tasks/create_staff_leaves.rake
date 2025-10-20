namespace :db do
  desc "Create staff leaves from CSV. (headers: Name,Country,Location,Employee Email,Start Date,End Date,Total days)"
  task create_staff_leaves: :environment do
    require 'csv'
    require 'logger'
    require 'securerandom'

    def parse_date_from_string(value)
      return value if value.is_a?(Date)
      return nil if value.nil?

      str = value.to_s.strip
      return nil if str == ''

      # If it's a pure number, treat as possible Excel serial (Windows Excel epoch)
      if str =~ /\A\d+\z/
        begin
          # Excel for Windows: 1900 date system (serial 1 == 1900-01-01), but Excel incorrectly treats 1900 as leap year.
          # Common workaround: epoch 1899-12-30
          return Date.new(1899,12,30) + str.to_i
        rescue => _
          # fall through to format attempts
        end
      end

      # Try specific common formats (US first)
      formats = ['%m/%d/%Y', '%m/%d/%y', '%m-%d-%Y', '%Y-%m-%d', '%d/%m/%Y']
      formats.each do |fmt|
        begin
          return Date.strptime(str, fmt)
        rescue ArgumentError
          # try next
        end
      end

      # Final fallback: try Date.parse (less deterministic)
      begin
        return Date.parse(str)
      rescue ArgumentError
        return nil
      end
    end

    csv_path = 'lib/tasks/staff_leaves.csv'
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    log_path = Rails.root.join('log', "create_staff_leaves_#{timestamp}.log")
    failures_csv_path = Rails.root.join('tmp', "staff_leaves_create_failures_#{timestamp}.csv")

    unless File.exist?(csv_path)
      puts "CSV not found at #{csv_path}"
      next
    end

    logger = Logger.new(log_path)
    fail_csv = CSV.open(failures_csv_path, 'w')
    fail_csv << %w[line_number employee_email reason row_json]

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
          logger.warn("Line #{lineno}: #{msg}")
          fail_csv << [lineno, email, msg, row.to_h.to_json]
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
            confirmed_at: Time.current
          )
          logger.info("Line #{lineno}: created user id=#{user.id} for email #{email}")
        end

        # parse dates
        begin
          start_date = parse_date_from_string(start_s)
          end_date   = parse_date_from_string(end_s)
        rescue => e
          msg = "Invalid dates (Start: #{start_s} End: #{end_s})"
          logger.warn("Line #{lineno}: #{msg}")
          fail_csv << [lineno, email, msg, row.to_h.to_json]
          failed += 1
          next
        end

        # parse total_days (integer)
        total_days = (total_days_raw.to_f).round  # allow floats, round to integer
        total_days = total_days.to_i

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
          # Try normal create (validations & callbacks)
          sl = StaffLeave.create!(attrs)
          succeeded += 1
          logger.info("Line #{lineno}: created StaffLeave id=#{sl.id} for user_id=#{user.id} (safe path)")
        rescue ActiveRecord::RecordInvalid => invalid_exc
          # Fallback: controlled bypass
          logger.warn("Line #{lineno}: create! failed: #{invalid_exc.record.errors.full_messages.join('; ')} - attempting fallback save(validate: false)")
          ActiveRecord::Base.transaction do
            # Ensure entitlements exist for the relevant years
            years = [start_date.year]
            years << end_date.year if end_date.year != start_date.year
            years.uniq.each do |y|
              StaffLeaveEntitlement.find_or_create_by!(user: user, year: y)
            end

            sl = StaffLeave.new(attrs)
            # set total_days to provided CSV value (we rely on the CSV)
            sl.total_days = total_days

            # Save without validation to bypass business-rule validations that we cannot satisfy during migration.
            sl.save!(validate: false)
            logger.info("Line #{lineno}: fallback created StaffLeave id=#{sl.id} for user_id=#{user.id}")

            # Ensure deductions & confirmations (call private methods if available)
            # After-create callbacks might have run; call deduce/create again safely if needed.
            begin
              sl.send(:deduct_entitlement_days) if sl.respond_to?(:deduct_entitlement_days, true)
            rescue => e
              logger.warn("Line #{lineno}: error running deduct_entitlement_days: #{e.class}: #{e.message}")
            end

            begin
              if sl.confirmations.count == 0
                sl.send(:create_initial_confirmation) if sl.respond_to?(:create_initial_confirmation, true)
              end
            rescue => e
              logger.warn("Line #{lineno}: error creating confirmations: #{e.class}: #{e.message}")
            end

            fallback_used += 1
          end
        end

      rescue => e
        logger.error("Line #{lineno}: unexpected error #{e.class}: #{e.message}\n#{e.backtrace.first(6).join("\n")}")
        fail_csv << [lineno, (email rescue ''), "#{e.class}: #{e.message}", row.to_h.to_json]
        failed += 1
      end
    end

    fail_csv.close
    puts "Import finished: processed=#{processed} succeeded=#{succeeded} fallback_used=#{fallback_used} failed=#{failed}"
    puts "Log: #{log_path}"
    puts "Failures CSV: #{failures_csv_path}"
  end
end
