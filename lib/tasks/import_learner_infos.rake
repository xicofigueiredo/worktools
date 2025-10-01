require 'csv'

namespace :admissions do
  desc "Import admissions CSV into learner_infos. ALWAYS generate student_number as yyyynnnn from start_date year. If start_date missing, student_number remains nil."
  task import_learner_infos: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'admissions_list.csv')

    unless File.exist?(csv_file_path)
      puts "CSV file not found at #{csv_file_path}"
      exit 1
    end

    dry_run = ENV['DRY_RUN'].to_s.downcase == 'true'
    retry_attempts = 5

    # helpers
    nilish = ->(v) { v.nil? || v.to_s.strip == '' || %w[n/a na null].include?(v.to_s.strip.downcase) }

    parse_date = ->(v) do
      return nil if nilish.call(v)
      s = v.to_s.strip
      if s.match?(/^\d+$/)
        begin
          serial = s.to_i
          Date.new(1899, 12, 30) + serial
        rescue
          nil
        end
      else
        begin
          Date.parse(s) rescue nil
        end
      end
    end

    parse_int = ->(v) do
      return nil if nilish.call(v)
      cleaned = v.to_s.gsub(/[^\d\-]/, '')
      cleaned == '' ? nil : cleaned.to_i
    end

    normalize = ->(s) { s.to_s.strip.downcase.gsub(/\s+/, ' ') }

    # flexible fetch: exact header then normalized header matching
    fetch = lambda do |row, *candidates|
      candidates.each do |cand|
        return row[cand] if row.headers.include?(cand)
        headers_norm = row.headers.map { |h| [normalize.call(h), h] }.to_h
        return row[headers_norm[normalize.call(cand)]] if headers_norm.key?(normalize.call(cand))
      end
      nil
    end

    # mapping for learner_info columns (extend as needed)
    FIELD_MAP = {
      # key => [header alternatives], parsing lambda is inline below
      status: ['Status'],
      programme: ['Programme (Section 2)', 'Programme'],
      full_name: ["Learner's Full Name (Section 5)", "Learner's Full Name"],
      curriculum_course_option: ['Curriculum/Course Option (Section 3)', 'Curriculum/Course Option'],
      grade_year: ['Grade/Year (Section 4)', 'Grade/Year'],
      start_date: ['Start Date'],
      transfer_of_programme_date: ['Transfer of Programme Date'],
      end_date: ['End Date'],
      end_day_communication: ['End Day Communication'],
      birthdate: ['Birthdate (5)', 'Birthdate'],
      personal_email: ['Personal Email (5)', 'Personal Email'],
      institutional_email: ['InstitutionalEmail', 'Institutional Email'],
      phone_number: ["Learner's Phone Number (5)", "Learner's Phone Number"],
      nationality: ["Learner's Nationality (5)", 'Nationality'],
      id_information: ["Learner's ID Information (5)"],
      fiscal_number: ["Learner's Fiscal Number (5)"],
      english_proficiency: ['English Proficiency (5)', 'English Proficiency'],
      home_address: ['Home Address (5: Street Address + City + Postal Code + Country)','Home Address'],
      gender: ["Learner's Gender (5)", 'Gender'],
      use_of_image_authorisation: ['Use of Image Authorisation (Section 7)'],
      emergency_protocol_choice: ['Emergency Protocol Choice (Section 9)'],
      parent1_full_name: ['Parent 1 - Full Name (Section 6)'],
      parent1_email: ['Parent 1 - Email (6)', 'Parent 1 - Email'],
      parent1_phone_number: ['Parent 1 - Phone Number (6)'],
      parent1_id_information: ['Parent 1 - ID Information (6)'],
      parent2_full_name: ['Parent 2 - Full Name (6)'],
      parent2_email: ['Parent 2 - Email (6)'],
      parent2_phone_number: ['Parent 2 - Phone Number (6)'],
      parent2_id_information: ['Parent 2 - ID Information (6)'],
      parent2_info_not_to_be_contacted: ['Parent 2 - Info (not to be contacted)'],
      registration_renewal: ['Registrarion Renewal', 'Registration Renewal'],
      registration_renewal_date: ['Registration Renewal Date'],
      deposit: ['Deposit'],
      sponsor: ['Sponsor'],
      payment_plan: ['Payment Plan (Section 8)', 'Payment Plan'],
      monthly_tuition: ['Monthly Tuition'],
      discount_mt: ['Discount MT'],
      scholarship: ['Scholarship'],
      billable_fee_per_month: ['Billable Fee/Month'],
      scholarship_percentage: ['Scholarship %'],
      admission_fee: ['Admission Fee'],
      discount_af: ['Discount AF'],
      billable_af: ['Billable AF'],
      registering_school_pt_plus: ['Registering School (In case of PT+)'],
      previous_schooling: ['Previous Schooling'],
      previous_school_status: ['Previous School Status (Section 4)'],
      previous_school_name: ['Previous School Name (Section 4)'],
      previous_school_email: ['Previous School Email (Section 4)'],
      withdrawal_category: ['Withdrawal Category'],
      withdrawal_reason: ['Withdrawal Reason'],
    }.freeze

    # small parser dispatch
    def parse_field(value, key, parse_date_lambda, parse_int_lambda, nilish_lambda)
      return nil if nilish_lambda.call(value)
      case key
      when :start_date, :transfer_of_programme_date, :end_date, :birthdate, :registration_renewal_date
        parse_date_lambda.call(value)
      when :age, :learners_fiscal_number, :monthly_tuition, :billable_fee_per_month,
           :scholarship_percentage, :admission_fee, :discount_af, :billable_af, :registration_renewal
        parse_int_lambda.call(value)
      when :english_proficiency, :use_of_image_authorisation, :emergency_protocol_choice
        # boolean-ish values
        v = value.to_s.strip.downcase
        return true if %w[true t yes y 1].include?(v)
        return false if %w[false f no n 0].include?(v)
        nil
      else
        value.to_s.strip
      end
    end

    # Generation helper for student_number for a given year (yyyynnnn).
    # Returns integer like 20210001. Retries a few times on conflicts.
    generate_student_number = lambda do |year, max_retries = 5|
      raise ArgumentError, "invalid year #{year}" unless year.is_a?(Integer) && year > 0

      attempt = 0
      begin
        attempt += 1
        student_number = nil

        ActiveRecord::Base.transaction(requires_new: true) do
          year_min = year * 10_000
          year_max = year_min + 9_999

          # find current maximum student_number in the year block
          max_sn = LearnerInfo.where(student_number: year_min..year_max).maximum(:student_number)

          seq = if max_sn.nil?
                  1
                else
                  (max_sn % 10_000) + 1
                end

          raise "year #{year} exhausted" if seq > 9_999

          candidate = year_min + seq

          # final check: doesn't exist
          if LearnerInfo.exists?(student_number: candidate)
            # someone else created in the meantime; throw to retry
            raise ActiveRecord::RecordNotUnique, "student_number #{candidate} exists"
          end

          student_number = candidate
          # don't persist here — caller will assign and save record
        end

        return student_number
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
        # conflict, retry up to max_retries
        retry if attempt < max_retries
        raise
      end
    end

    # counters
    total = 0
    created = 0
    updated = 0
    errors = 0

    puts "Importing CSV: #{csv_file_path} (DRY_RUN=#{dry_run})"
    CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8') do |row|
      total += 1
      begin
        # build attr hash for LearnerInfo
        attrs = {}

        FIELD_MAP.each do |attr, header_candidates|
          raw = fetch.call(row, *header_candidates)
          parsed = parse_field(raw, attr, parse_date, parse_int, nilish)
          attrs[attr] = parsed
        end

        # Determine start_date (strict: only if CSV had it parsed)
        start_date = attrs[:start_date] # already parsed date or nil

        if start_date.present?
          year = start_date.year
          # generate student_number for that year (overrides any provided student_number)
          student_number = generate_student_number.call(year)
          attrs[:student_number] = student_number
        else
          # ensure student_number is nil if start_date not present
          attrs[:student_number] = nil
        end

        # find existing by institutional_email OR by some other stable identifier if you prefer
        found_li = nil
        if attrs[:institutional_email].present?
          found_li = LearnerInfo.find_by(institutional_email: attrs[:institutional_email])
        end

        # fallback: if a record exists with identical combination of name + birthdate, pick that (optional)
        if found_li.nil? && attrs[:learners_full_name].present? && attrs[:birthdate].present?
          found_li = LearnerInfo.find_by(learners_full_name: attrs[:learners_full_name], birthdate: attrs[:birthdate])
        end

        if found_li
          # reassign attributes (we always overwrite student_number if start_date present)
          found_li.assign_attributes(attrs)
          if dry_run
            updated += 1
          else
            found_li.save!
            updated += 1
          end
        else
          if dry_run
            created += 1
          else
            li = LearnerInfo.new(attrs)
            # optional: attach user if exists (non-fatal)
            if attrs[:institutional_email].present?
              u = User.find_by(email: attrs[:institutional_email])
              li.user = u if u
            end
            li.save!
            created += 1
          end
        end

        # progress log
        puts "[#{total}] processed student_number=#{attrs[:student_number] || 'nil'}" if (total % 500).zero?

      rescue => e
        errors += 1
        puts "[#{total}] ERROR: #{e.class} - #{e.message}"
        Rails.logger.error "Admissions import error (row #{total}): #{e.full_message}"
      end
    end

    puts "Done."
    puts "Total rows: #{total}"
    puts "Created: #{created}"
    puts "Updated: #{updated}"
    puts "Errors: #{errors}"
    puts "Note: student_number generated only when start_date present; otherwise remains nil."
  end
end
