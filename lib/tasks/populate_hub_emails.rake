namespace :hubs do
  desc "Populate hub emails from a CSV file (Hub Name, Hub Email)"
  task :populate_emails => :environment do
    require 'csv'

    # 1. Configuration: Path to your CSV
    csv_path = Rails.root.join('lib', 'tasks', 'hub_emails.csv')

    unless File.exist?(csv_path)
      abort "ERROR: CSV file not found at: #{csv_path}"
    end

    # 2. Levenshtein Distance helper for fuzzy matching [cite: 7, 8, 9, 10]
    def get_distance(a, b)
      a, b = a.to_s.downcase.strip, b.to_s.downcase.strip
      return b.length if a.empty?
      return a.length if b.empty?

      matrix = Array.new(a.length + 1) { Array.new(b.length + 1, 0) }
      (0..a.length).each { |i| matrix[i][0] = i }
      (0..b.length).each { |j| matrix[0][j] = j }

      (1..a.length).each do |i|
        (1..b.length).each do |j|
          cost = a[i - 1] == b[j - 1] ? 0 : 1
          matrix[i][j] = [matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost].min
        end
      end
      matrix[a.length][b.length]
    end

    # 3. Load all Hubs into memory for matching
    all_hubs = Hub.all.to_a
    csv_text = File.read(csv_path, encoding: 'bom|utf-8')
    csv = CSV.parse(csv_text, headers: true)

    # Detect header names (flexible for case sensitivity)
    hub_name_key = csv.headers.find { |h| h.to_s.downcase.strip == 'hub name' }
    hub_email_key = csv.headers.find { |h| h.to_s.downcase.strip == 'hub email' }

    csv.each_with_index do |row, idx|
      raw_name = row[hub_name_key].to_s.strip
      email_to_set = row[hub_email_key].to_s.strip

      next if raw_name.empty? || email_to_set.empty?

      # 4. Attempt Exact Match [cite: 14]
      hub = Hub.find_by("LOWER(name) = ?", raw_name.downcase)

      # 5. Fallback to Fuzzy Match if exact fails [cite: 18]
      if hub.nil?
        closest_match = all_hubs.min_by { |h| get_distance(h.name, raw_name) }
        dist = get_distance(closest_match.name, raw_name)

        if dist <= 3 # Threshold for "close enough"
          hub = closest_match
          puts "Fuzzy match: Mapping '#{raw_name}' to DB Hub '#{hub.name}' (dist: #{dist})"
        else
          puts "Skipping '#{raw_name}': No close match found in database."
          next
        end
      end

      # 6. Update the record
      if hub.update(hub_email: email_to_set)
        puts "✅ Updated #{hub.name} with #{email_to_set}"
      else
        puts "❌ Failed to update #{hub.name}: #{hub.errors.full_messages.join(', ')}"
      end
    end

    puts "Task complete."
  end
end
