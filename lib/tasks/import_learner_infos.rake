# lib/tasks/import_learner_infos_verbose.rake
require 'csv'

namespace :admissions do
  desc "Import admissions CSV into learner_infos. Generates student_number from start_date year. Prints status for every row."
  task import_learner_infos: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'admissions_list.csv')

    unless File.exist?(csv_file_path)
      puts "CSV file not found at #{csv_file_path}"
      exit 1
    end

    dry_run = ENV['DRY_RUN'].to_s.downcase == 'true'
    puts "Starting verbose import (DRY_RUN=#{dry_run})"
    puts "CSV: #{csv_file_path}"
    puts

    # -----------------------
    # Encoding helper
    # -----------------------
    to_utf8 = lambda do |val|
      return nil if val.nil?
      s = val.is_a?(String) ? val.dup : val.to_s
      return s if s.encoding == Encoding::UTF_8 && s.valid_encoding?

      encodings_to_try = ['UTF-8', 'Windows-1252', 'ISO-8859-1', 'ISO-8859-15']
      encodings_to_try.each do |enc|
        begin
          candidate = s.dup.force_encoding(enc)
          return candidate.encode('UTF-8')
        rescue Encoding::InvalidByteSequenceError, Encoding::UndefinedConversionError
          next
        end
      end

      begin
        return s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      rescue
        return s.force_encoding('BINARY').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      end
    end

    # -----------------------
    # helpers / parsers
    # -----------------------
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

    normalize = ->(s) { to_utf8.call(s).to_s.strip.downcase.gsub(/\s+/, ' ') }

    # flexible fetch: exact header then normalized header matching
    fetch = lambda do |row, *candidates|
      headers_norm = row.headers.map { |h| [ normalize.call(h), h ] }.to_h
      candidates.each do |cand|
        return to_utf8.call(row[cand]) if row.headers.include?(cand)
        key = normalize.call(cand)
        if headers_norm.key?(key)
          raw = row[ headers_norm[key] ]
          return to_utf8.call(raw)
        end
      end
      nil
    end

    # FIELD_MAP: map to your DB columns (keys are learner_info attributes)
    FIELD_MAP = {
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

    # parse_field (lambda)
    parse_field = lambda do |value, key|
      return nil if nilish.call(value)
      case key
      when :start_date, :transfer_of_programme_date, :end_date, :birthdate, :registration_renewal_date
        parse_date.call(value)
      when :monthly_tuition, :billable_fee_per_month, :scholarship_percentage,
           :admission_fee, :discount_af, :billable_af, :registration_renewal, :fiscal_number
        parse_int.call(value)
      when :english_proficiency, :use_of_image_authorisation, :emergency_protocol_choice
        v = value.to_s.strip.downcase
        return true if %w[true t yes y 1].include?(v)
        return false if %w[false f no n 0].include?(v)
        nil
      else
        to_utf8.call(value).to_s.strip
      end
    end

    # student number generator (same approach as before)
    generate_student_number = lambda do |year, max_retries = 5|
      raise ArgumentError, "invalid year #{year}" unless year.is_a?(Integer) && year > 0

      attempt = 0
      begin
        attempt += 1
        student_number = nil

        ActiveRecord::Base.transaction(requires_new: true) do
          year_min = year * 10_000
          year_max = year_min + 9_999

          max_sn = LearnerInfo.where(student_number: year_min..year_max).maximum(:student_number)
          seq = max_sn.nil? ? 1 : (max_sn % 10_000) + 1
          raise "year #{year} exhausted" if seq > 9_999

          candidate = year_min + seq
          if LearnerInfo.exists?(student_number: candidate)
            raise ActiveRecord::RecordNotUnique, "student_number #{candidate} exists"
          end
          student_number = candidate
        end

        return student_number
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
        retry if attempt < max_retries
        raise
      end
    end

    # counters
    total = 0
    created = 0
    updated = 0
    no_changes = 0
    errors = 0

    # print detected headers for debugging
    sample_table = CSV.read(csv_file_path, headers: true, encoding: 'bom|utf-8')
    puts "Detected CSV headers (#{sample_table.headers.size}):"
    sample_table.headers.each_with_index { |h,i| puts "  #{i+1}. #{to_utf8.call(h).inspect}" }
    puts

    CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8') do |row|
      total += 1
      row_num = total + 1 # approximate CSV row number (including header)
      begin
        attrs = {}

        FIELD_MAP.each do |attr, header_candidates|
          raw = fetch.call(row, *header_candidates)
          parsed = parse_field.call(raw, attr)
          attrs[attr] = parsed
        end

        # compute start_date and student_number
        start_date = attrs[:start_date]
        if start_date.present?
          year = start_date.year
          student_number = generate_student_number.call(year)
          attrs[:student_number] = student_number
        else
          attrs[:student_number] = nil
        end

        # identifier for logs
        ident = attrs[:institutional_email].presence || "#{attrs[:full_name].to_s[0..40]}|#{attrs[:birthdate].to_s}"

        # find existing by institutional email OR by full_name + birthdate
        found = nil
        if attrs[:institutional_email].present?
          found = LearnerInfo.find_by(institutional_email: attrs[:institutional_email])
        end

        if found.nil? && attrs[:full_name].present? && attrs[:birthdate].present?
          found = LearnerInfo.find_by(full_name: attrs[:full_name], birthdate: attrs[:birthdate])
        end

        if found
          # compare current values and new ones for diffs (string compare)
          diffs = {}
          attrs.each do |k,v|
            current = found.send(k)
            # normalize for comparison
            cur_s = current.respond_to?(:strftime) ? current.to_s : (current.nil? ? '' : current.to_s)
            new_s = v.respond_to?(:strftime) ? v.to_s : (v.nil? ? '' : v.to_s)
            if cur_s != new_s
              diffs[k] = { from: cur_s, to: new_s }
            end
          end

          if diffs.empty?
            no_changes += 1
            puts "Row #{row_num}: NO CHANGES for #{ident}"
          else
            if dry_run
              updated += 1
              puts "Row #{row_num}: WOULD UPDATE #{ident} - changes: #{diffs.keys.join(', ')}"
            else
              found.assign_attributes(attrs)
              found.save!
              updated += 1
              puts "Row #{row_num}: UPDATED #{ident} (id=#{found.id}) - changes: #{diffs.keys.join(', ')}"
            end
          end
        else
          if dry_run
            created += 1
            puts "Row #{row_num}: WOULD CREATE #{ident} student_number=#{attrs[:student_number].inspect}"
          else
            li = LearnerInfo.new(attrs)
            if attrs[:institutional_email].present?
              u = User.find_by(email: attrs[:institutional_email])
              li.user = u if u
            end
            li.save!
            created += 1
            puts "Row #{row_num}: CREATED id=#{li.id} #{ident} student_number=#{attrs[:student_number].inspect}"
          end
        end

      rescue => e
        errors += 1
        puts "Row #{row_num}: ERROR for #{(defined?(ident) && ident) ? ident : 'UNKNOWN'} -> #{e.class}: #{e.message}"
        # print short backtrace for debugging
        e.backtrace.first(5).each { |bt| puts "  #{bt}" }
        Rails.logger.error "Admissions import error (row #{row_num}): #{e.full_message}"
      end
    end

    puts
    puts "Import finished."
    puts "Total rows processed: #{total}"
    puts "Created: #{created}"
    puts "Updated: #{updated}"
    puts "No changes: #{no_changes}"
    puts "Errors: #{errors}"
    puts "DRY_RUN=#{dry_run}"
  end
end
