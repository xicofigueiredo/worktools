require 'csv'
namespace :db do
  desc "Import user->department memberships from CSV (headers include user_email and department_name)"
  task import_user_departments: :environment do
    csv_path = 'lib/tasks/user_departments.csv'
    unless File.exist?(csv_path)
      puts "CSV not found at #{csv_path}. Place CSV there or change csv_path in task."
      next
    end

    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    log_path = Rails.root.join('log', "import_user_departments_#{timestamp}.log")
    failures_path = Rails.root.join('tmp', "import_user_departments_failures_#{timestamp}.csv")
    logger = Logger.new(log_path)

    # tolerant CSV loader: tries common encodings and returns CSV::Table
    def load_csv_tolerant(path)
      begin
        return CSV.read(path, headers: true, encoding: 'bom|utf-8')
      rescue => _e
        # fallback below
      end

      raw = File.binread(path)
      ['UTF-8', 'ISO-8859-1', 'Windows-1252', 'ASCII-8BIT'].each do |src_enc|
        begin
          utf8 = raw.encode('UTF-8', src_enc, invalid: :replace, undef: :replace, replace: '')
          return CSV.parse(utf8, headers: true)
        rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
          next
        end
      end

      # final fallback - force & scrub
      utf8 = raw.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      CSV.parse(utf8, headers: true)
    end

    # flexible header detection helper: returns actual header string or nil
    def detect_header(headers, candidates = [])
      lc = headers.map { |h| h.to_s.downcase }
      candidates.each do |cand|
        idx = lc.index { |h| h.include?(cand) }
        return headers[idx] if idx
      end
      nil
    end

    rows = load_csv_tolerant(csv_path)
    total = rows.size

    # Open failures CSV to collect rows we couldn't process
    CSV.open(failures_path, 'w') do |fail_csv|
      fail_csv << %w[line_number user_email department_name reason raw_row_json]

      created = 0
      skipped_existing = 0
      failed = 0
      processed = 0

      rows.each_with_index do |row, i|
        lineno = i + 2
        processed += 1
        begin
          # sanitize row -> strings safe for DB queries
          row_h = row.to_h.transform_values { |v| v.nil? ? '' : v.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '').scrub('') }

          # detect likely headers
          headers = row.headers || row_h.keys
          email_col = detect_header(headers, ['email', 'user_email', 'employee email', 'employee_email', 'user email'])
          dept_col  = detect_header(headers, ['department', 'department_name', 'dept', 'department name', 'department_name'])

          # fallback to common keys if detection failed
          email_val = (row_h[email_col] || row_h['email'] || row_h['user_email'] || row_h['employee email'] || row_h['employee_email']).to_s.strip
          dept_val  = (row_h[dept_col]  || row_h['department'] || row_h['department_name'] || row_h['dept'] || row_h['department name']).to_s.strip

          if email_val.blank?
            reason = 'missing email'
            logger.warn("Line #{lineno}: #{reason}")
            fail_csv << [lineno, email_val, dept_val, reason, row_h.to_json]
            failed += 1
            next
          end

          if dept_val.blank?
            reason = 'missing department name'
            logger.warn("Line #{lineno}: #{reason} for email #{email_val}")
            fail_csv << [lineno, email_val, dept_val, reason, row_h.to_json]
            failed += 1
            next
          end

          # Normalize email for lookup
          email_lookup = email_val.downcase

          # Find user (case-insensitive)
          user = User.where('lower(email) = ?', email_lookup).first
          unless user
            reason = "user not found"
            logger.warn("Line #{lineno}: #{reason} (#{email_lookup})")
            fail_csv << [lineno, email_lookup, dept_val, reason, row_h.to_json]
            failed += 1
            next
          end

          # Find department (case-insensitive)
          dept = Department.where('lower(name) = ?', dept_val.downcase).first
          unless dept
            reason = "department not found"
            logger.warn("Line #{lineno}: #{reason} ('#{dept_val}')")
            fail_csv << [lineno, email_lookup, dept_val, reason, row_h.to_json]
            failed += 1
            next
          end

          # Create join record if missing
          # Use the application join model if it exists; typical name is UsersDepartment
          begin
            ud = UsersDepartment.find_or_create_by!(user_id: user.id, department_id: dept.id)
            if ud.persisted?
              created += 1
              logger.info("Line #{lineno}: created UsersDepartment user_id=#{user.id} department_id=#{dept.id}")
            else
              skipped_existing += 1
              logger.info("Line #{lineno}: users_department already exists for user_id=#{user.id}, department_id=#{dept.id}")
            end
          rescue ActiveRecord::RecordNotUnique
            # Unique index race or duplicate -> treat as skipped
            skipped_existing += 1
            logger.info("Line #{lineno}: users_department already exists (unique conflict) user_id=#{user.id} dept_id=#{dept.id}")
          end

        rescue => e
          logger.error("Line #{lineno}: unexpected error: #{e.class}: #{e.message}\n#{e.backtrace.first(6).join("\n")}")
          fail_csv << [lineno, (email_val rescue ''), (dept_val rescue ''), "exception: #{e.class}: #{e.message}", (row_h rescue {}).to_json]
          failed += 1
          next
        end
      end

      puts "Import finished. processed=#{processed} created=#{created} skipped_existing=#{skipped_existing} failed=#{failed} (see #{log_path} and #{failures_path})"
      logger.close if logger.respond_to?(:close)
    end
  end
end
