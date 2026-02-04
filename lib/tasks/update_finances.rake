namespace :finance do
  desc "Update Learner Finances from CSV (converts fees to decimals and bypasses notifications)"
  task update_from_csv: :environment do
    require 'csv'

    # 1. Setup File Path
    csv_path = Rails.root.join('lib', 'tasks', 'learner_finances.csv').to_s
    unless File.exist?(csv_path)
      abort "ERROR: CSV file not found at: #{csv_path}"
    end

    puts "Reading CSV from: #{csv_path}"

    # 2. Read and Pre-process Headers
    puts "Reading file..."

    begin
      # Try standard UTF-8 (with BOM check)
      csv_text = File.read(csv_path, encoding: 'bom|utf-8')
      # Force a check to ensure the bytes are valid
      raise ArgumentError unless csv_text.valid_encoding?
    rescue ArgumentError
      puts "Notice: File is not valid UTF-8. Attempting Windows-1252 (Excel) fallback..."
      # Fallback: Read as Windows-1252 and convert to UTF-8
      csv_text = File.read(csv_path, encoding: 'Windows-1252:UTF-8')
    end

    # Scrub any remaining weird characters just in case
    csv_text = csv_text.scrub

    lines = csv_text.lines
    header_line = lines.first

    # Detect separator
    possible_separators = [',', ';', "\t"]
    separator = possible_separators.max_by { |sep| header_line.count(sep) }

    puts "Detected separator: '#{separator}'"

    # HACK: Handle duplicate "Discount" headers by renaming them based on position.
    # We assume the order: Monthly Fee, Discount, Scholarship... Renewal Fee, Discount...
    # We replace the first occurrence of "Discount" with "Discount MF" and the second with "Discount RF"
    if header_line.scan(/Discount/i).count > 1
      # Replace first "Discount"
      header_line = header_line.sub(/Discount/i, 'Discount MF')
      # Replace next "Discount"
      header_line = header_line.sub(/Discount/i, 'Discount RF')
      lines[0] = header_line
      puts "Duplicate 'Discount' headers detected. Renamed to 'Discount MF' and 'Discount RF' for parsing."
    end

    # Reassemble CSV text
    processed_csv_text = lines.join

    # 3. Parse CSV
    csv = CSV.parse(processed_csv_text, headers: true, col_sep: separator)

    # Normalize headers for easy access
    header_map = {}
    csv.headers.each do |h|
      next if h.nil?
      normalized = h.to_s.strip.downcase.gsub(/\s+/, '_') # e.g., "Monthly Fee" -> "monthly_fee"
      header_map[normalized] = h
    end

    # 4. Processing Variables
    success_count = 0
    errors = []

    puts "Starting update process for #{csv.count} rows..."
    puts "-" * 50

    csv.each_with_index do |row, idx|
      row_num = idx + 2 # Account for header + 0-index

      # Fetch Full Name
      raw_name = row[header_map['full_name']].to_s

      if raw_name.blank?
        errors << "Row #{row_num}: Skipped (Empty Name)"
        next
      end

      # Find Learner
      # Using ILIKE or LOWER match to be safe
      learner = LearnerInfo.where("LOWER(full_name) = ?", raw_name.downcase).first

      unless learner
        errors << "Row #{row_num}: Learner not found for name '#{raw_name}'"
        next
      end

      # Find Finance Record
      finance = learner.learner_finance

      unless finance
        errors << "Row #{row_num}: No Finance record found for '#{raw_name}' (ID: #{learner.id})"
        next
      end

      # 5. Extract Values
      # Helper to parse decimal safely. Returns nil if cell is empty, so we don't overwrite with 0.0 unless intended.
      # If you want to force 0.0 for empty cells, change `return nil` to `return 0.0`.
      parse_decimal = ->(key_fragment) {
        val = row[header_map[key_fragment]]
        val.present? ? val.to_s.gsub(',', '.').to_f : nil
      }

      # Mapping CSV columns to DB columns
      updates = {}

      # Monthly Fee Block
      mf      = parse_decimal.call('monthly_fee')
      disc_mf = parse_decimal.call('discount_mf') # Mapped from first "Discount"
      schol   = parse_decimal.call('scholarship')
      bill_mf = parse_decimal.call('billable_monthly_fee')

      updates[:monthly_fee] = mf if mf
      updates[:discount_mf] = disc_mf if disc_mf
      updates[:scholarship] = schol if schol
      updates[:billable_mf] = bill_mf if bill_mf

      # Renewal Fee Block
      rf      = parse_decimal.call('renewal_fee')
      disc_rf = parse_decimal.call('discount_rf') # Mapped from second "Discount"
      bill_rf = parse_decimal.call('billable_renewal_fee')

      updates[:renewal_fee] = rf if rf
      updates[:discount_rf] = disc_rf if disc_rf
      updates[:billable_rf] = bill_rf if bill_rf

      if updates.empty?
        errors << "Row #{row_num}: No data to update for '#{raw_name}'"
        next
      end

      # 6. Perform Update (Silent)
      # update_columns bypasses callbacks (before_save, after_commit, etc.)
      begin
        if finance.update_columns(updates)
          success_count += 1
          print "." # Progress indicator
        else
          errors << "Row #{row_num}: Database error updating '#{raw_name}'"
        end
      rescue StandardError => e
        errors << "Row #{row_num}: Exception for '#{raw_name}': #{e.message}"
      end
    end

    puts "\n" + "-" * 50
    puts "Update Summary"
    puts "-" * 50
    puts "Total Processed: #{csv.count}"
    puts "Successful:      #{success_count}"
    puts "Errors:          #{errors.count}"

    if errors.any?
      puts "\nError Details:"
      errors.each { |e| puts " - #{e}" }
    end
  end
end
