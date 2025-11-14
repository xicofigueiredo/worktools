require 'csv'

namespace :admissions do
  desc "Check status discrepancies between admissions CSV and database LearnerInfos"
  task check_status_discrepancies: :environment do
    csv_file_path = Rails.root.join('lib', 'tasks', 'admissions_list.csv')
    unless File.exist?(csv_file_path)
      puts "CSV file not found at #{csv_file_path}"
      exit 1
    end

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

    nilish = ->(v) { v.nil? || v.to_s.strip == '' || %w[n/a na null].include?(v.to_s.strip.downcase) }

    normalize = ->(s) { to_utf8.call(s).to_s.strip.downcase.gsub(/\s+/, ' ') }

    fetch = lambda do |row, *candidates|
      headers_norm = row.headers.map { |h| [normalize.call(h), h] }.to_h
      candidates.each do |cand|
        return to_utf8.call(row[cand]) if row.headers.include?(cand)
        key = normalize.call(cand)
        if headers_norm.key?(key)
          raw = row[headers_norm[key]]
          return to_utf8.call(raw)
        end
      end
      nil
    end

    discrepancies = []
    total = 0
    found_matches = 0
    no_matches = 0

    puts "Checking status discrepancies..."
    puts "CSV: #{csv_file_path}"
    puts

    CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8') do |row|
      total += 1
      row_num = total + 1

      csv_status_raw = fetch.call(row, 'Status')
      csv_status = to_utf8.call(csv_status_raw).to_s.strip if csv_status_raw
      next if csv_status.blank?  # Skip rows without status

      full_name = fetch.call(row, "Learner's Full Name (Section 5)", "Learner's Full Name")
      full_name = to_utf8.call(full_name).to_s.strip if full_name

      institutional_email = fetch.call(row, 'InstitutionalEmail', 'Institutional Email')
      institutional_email = to_utf8.call(institutional_email).to_s.strip.downcase if institutional_email

      birthdate_raw = fetch.call(row, 'Birthdate (5)', 'Birthdate')
      birthdate = nil
      if birthdate_raw
        s = birthdate_raw.to_s.strip
        if s.match?(/^\d+$/)
          begin
            serial = s.to_i
            birthdate = Date.new(1899, 12, 30) + serial
          rescue
            nil
          end
        else
          begin
            birthdate = Date.parse(s) rescue nil
          end
        end
      end

      ident = institutional_email.presence || "#{full_name.to_s[0..40]}|#{birthdate&.to_s}"

      found = nil
      if institutional_email.present?
        found = LearnerInfo.find_by(institutional_email: institutional_email)
      end
      if found.nil? && full_name.present? && birthdate.present?
        found = LearnerInfo.find_by(full_name: full_name, birthdate: birthdate)
      end

      if found
        found_matches += 1
        db_status = found.status.to_s.strip
        if csv_status != db_status
          discrepancies << {
            row_num: row_num,
            ident: ident,
            full_name: full_name,
            institutional_email: institutional_email,
            birthdate: birthdate&.to_s,
            csv_status: csv_status,
            db_status: db_status,
            db_id: found.id
          }
        end
      else
        no_matches += 1
        puts "Row #{row_num}: NO MATCH found for #{ident} (CSV status: #{csv_status.inspect})"
      end
    end

    puts
    puts "Check finished."
    puts "Total rows processed: #{total}"
    puts "Matches found: #{found_matches}"
    puts "No matches: #{no_matches}"
    puts "Discrepancies: #{discrepancies.size}"
    puts

    if discrepancies.any?
      puts "DISCREPANCIES:"
      puts "-" * 80
      discrepancies.each do |disc|
        puts "Row #{disc[:row_num]}: #{disc[:full_name]} (#{disc[:ident]})"
        puts "  CSV Status: #{disc[:csv_status].inspect}"
        puts "  DB Status:  #{disc[:db_status].inspect} (LearnerInfo ID: #{disc[:db_id]})"
        puts
      end
    else
      puts "No discrepancies found!"
    end
  end
end
