namespace :hubs do
  desc "Update hubs from CSV file (path set inside task). Interactive prompt for fuzzy matches."
  task :update_from_csv => :environment do
    require 'csv'

    csv_path = Rails.root.join('lib', 'tasks', 'hubs.csv').to_s

    unless File.exist?(csv_path)
      abort "ERROR: CSV file not found at: #{csv_path}"
    end

    csv_text = File.read(csv_path, encoding: 'bom|utf-8')

    first_line = csv_text.each_line.detect { |l| l && l.strip.size > 0 } || ''
    possible_separators = [',', ';', "\t"]
    detected = possible_separators.max_by { |sep| first_line.count(sep) }

    puts "Detected separator: #{detected.inspect}"
    puts "First line preview: #{first_line.strip[0,200].inspect}"

    csv = CSV.parse(csv_text, headers: true, col_sep: detected)

    # Normalize headers: map normalized_header -> actual_header
    header_map = {}
    csv.headers.each do |h|
      next if h.nil?
      normalized = h.to_s.strip.downcase
      header_map[normalized] = h
    end

    # Add RM-related normalized header names so we detect common variants
    expected_headers = [
      'hub name', 'country', 'province', 'hub type', 'hub address',
      'google maps link', 'hub capacity', 'exam centre', 'exam center',
      # RM variants
      'rm', 'regional manager', 'regional_manager', 'rm email', 'regional manager email'
    ]
    missing = expected_headers.reject { |eh| header_map.key?(eh) }
    if missing.any?
      puts "Warning: some expected headers not found (normalized): #{missing.join(', ')}"
      puts "Available headers (normalized): #{header_map.keys.join(', ')}"
    end

    def levenshtein_distance(a, b)
      a = a.to_s.downcase.strip
      b = b.to_s.downcase.strip
      matrix = Array.new(a.length + 1) { Array.new(b.length + 1, 0) }

      (0..a.length).each { |i| matrix[i][0] = i }
      (0..b.length).each { |j| matrix[0][j] = j }

      (1..a.length).each do |i|
        (1..b.length).each do |j|
          cost = a[i - 1] == b[j - 1] ? 0 : 1
          matrix[i][j] = [
            matrix[i - 1][j] + 1,
            matrix[i][j - 1] + 1,
            matrix[i - 1][j - 1] + cost
          ].min
        end
      end

      matrix[a.length][b.length]
    end

    hubs = Hub.all.to_a

    interactive = STDIN.tty?

    csv.each_with_index do |row, idx|
      hub_name_field = header_map['hub name']
      hub_name = hub_name_field ? row[hub_name_field].to_s.strip : row[0].to_s.strip

      if hub_name.empty?
        puts "Skipping row #{idx + 1}: empty 'Hub Name'"
        next
      end

      downcased_hub_name = hub_name.downcase

      hub = Hub.find_by("LOWER(name) = ?", downcased_hub_name)

      if hub
        puts "Exact match found for #{hub_name}: #{hub.name}"
      else
        # compute distances for all hubs
        distances = hubs.map do |h|
          next if h.name.nil?
          [h, levenshtein_distance(h.name, hub_name)]
        end.compact

        if distances.empty?
          puts "No hubs in DB to match against; creating new hub for #{hub_name} by default."
          choice = 2
        else
          sorted = distances.sort_by { |h, d| d }
          closest_hub, min_dist = sorted.first

          if !interactive
            if min_dist <= 2
              hub = closest_hub
              puts "Non-interactive: using fuzzy match for #{hub_name}: #{hub.name} (distance: #{min_dist})"
            else
              puts "Non-interactive: no match for #{hub_name} (closest distance: #{min_dist}); skipping."
              next
            end
          else
            puts "-" * 80
            puts "Row #{idx + 1}: '#{hub_name}' (closest fuzzy match: '#{closest_hub.name}' — distance #{min_dist})"
            puts "Choose an action:"
            puts "  1) Update the closest hub: '#{closest_hub.name}' (distance #{min_dist})"
            puts "  2) Create a NEW hub named '#{hub_name}' and update it with this row's data"
            puts "  3) Skip this row"
            print "Enter 1, 2, or 3: "
            input = STDIN.gets
            if input.nil?
              puts "No input received — skipping."
              next
            end
            choice = input.chomp.to_i
            unless [1,2,3].include?(choice)
              puts "Invalid choice '#{input.chomp}' — skipping."
              next
            end
          end
        end

        # Process interactive choice (or default when distances empty)
        if interactive
          case choice
          when 1
            hub = closest_hub
            puts "You chose to update existing hub: #{hub.name}"
          when 2
            hub = Hub.new(name: hub_name)
            puts "You chose to create a new hub: #{hub_name}"
          when 3
            puts "You chose to skip row #{idx + 1}."
            next
          end
        end
      end

      # Safe assignment helper (uses header_map to fetch actual header keys)
      get = ->(key_normalized) {
        h = header_map[key_normalized]
        h ? row[h].to_s : ''
      }

      hub.country = get.call('country')
      hub.region = get.call('province')
      hub.hub_type = get.call('hub type')
      hub.address = get.call('hub address')
      hub.google_map_link = get.call('google maps link')
      hub.capacity = get.call('hub capacity').to_i
      exam_val = get.call('exam centre')
      hub.exam_center = (exam_val.to_s.strip != '0' && !exam_val.to_s.strip.empty?)

      rm_email = nil
      %w[rm regional manager regional_manager rm email rm_email regional manager email].each do |nm|
        if header_map.key?(nm)
          rm_email = (row[header_map[nm]] || '').to_s.strip
          break if rm_email && !rm_email.empty?
        end
      end

      if rm_email && !rm_email.empty?
        rm_email_down = rm_email.downcase
        user = User.where("LOWER(email) = ?", rm_email_down).first

        if user.nil? && interactive
          puts "Regional manager with email '#{rm_email}' not found."
          print "If you'd like to try a different email for this hub, type it now (or press Enter to skip assignment): "
          alt = STDIN.gets
          if alt
            alt = alt.chomp.strip
            if !alt.empty?
              user = User.where("LOWER(email) = ?", alt.downcase).first
              if user.nil?
                puts "Still not found for '#{alt}'. Will skip RM assignment for this hub."
              end
            else
              puts "Skipping RM assignment for this hub."
            end
          else
            puts "No input — skipping RM assignment."
          end
        end

        if user
          hub.regional_manager = user
          puts "Assigning regional manager #{user.email} to hub #{hub.name}."
        else
          puts "No user assigned for RM (CSV value: #{rm_email.inspect})."
        end
      end

      if hub.save
        puts "Updated #{hub.name} successfully."
      else
        puts "Failed to save #{hub.name || hub_name}: #{hub.errors.full_messages.join(', ')}"
      end
    end
  end
end
