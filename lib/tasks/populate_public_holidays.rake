# Rake task to populate public_holidays from CSV (columns: country,hub,name,date,recurring)
require 'csv'

namespace :db do
  desc "Populate public_holidays from CSV (expects headers: country,hub,name,date,recurring)"
  task populate_public_holidays: :environment do
    csv_path = 'lib/tasks/public_holidays.csv'
    unless File.exist?(csv_path)
      puts "CSV file not found at \#{csv_path}."
      next
    end
    CSV.foreach(csv_path, headers: true) do |row|
      country = row['country'].to_s.strip
      hub_name = row['hub'].to_s.strip
      hub = nil
      if hub_name.present?
        # case-insensitive exact match first
        hub = Hub.where('LOWER(name) = ?', hub_name.downcase).first
        # try trimmed accents-insensitive fallback
        if hub.nil?
          normalized = I18n.transliterate(hub_name).downcase
          hub = Hub.all.find { |h| I18n.transliterate(h.name).downcase == normalized }
        end
      end
      hub_id = hub ? hub.id : nil
      begin
        date = Date.parse(row['date'].to_s)
      rescue
        puts "Skipping row with invalid date: \#{row.inspect}"
        next
      end
      name = row['name'].to_s.strip
      recurring = row['recurring'].to_s.strip.downcase == 'true'
      if name.empty?
        puts "Skipping row with missing name: \#{row.inspect}"
        next
      end
      attrs = { country: country, hub_id: hub_id, date: date }
      ph = PublicHoliday.find_or_initialize_by(attrs)
      ph.name = name
      ph.recurring = recurring
      if ph.changed?
        ph.save!
        puts "Created/Updated public holiday: \#{ph.inspect}"
      end
    end
    puts "Done. Processed CSV: \#{csv_path}"  end
end
