namespace :db do
  desc "Create departments from CSV. (headers: name,manager,superior_department)"
  task import_departments: :environment do
    require 'csv'
    csv_path = 'lib/tasks/departments.csv'
    unless File.exist?(csv_path)
      puts "CSV not found at #{csv_path}"
      next
    end

    created = []
    errors = []

    # First pass: create or find departments and attach manager if present
    CSV.foreach(csv_path, headers: true).with_index(2) do |row, lineno|
      name = row['name'].to_s.strip
      manager_email = row['manager'].to_s.strip.presence
      if name.blank?
        errors << [lineno, 'missing department name']
        next
      end

      begin
        dept = Department.find_or_create_by!(name: name)
        if manager_email.present?
          manager = User.find_by(email: manager_email.downcase)
          if manager
            dept.update!(manager: manager)
          else
            puts "Line #{lineno}: manager not found for email #{manager_email} — skipping manager assignment"
          end
        end
        created << dept
      rescue => e
        errors << [lineno, e.message]
      end
    end

    # Second pass: assign superior relationships
    CSV.foreach(csv_path, headers: true).with_index(2) do |row, lineno|
      name = row['name'].to_s.strip
      next if name.blank?
      superior_name = row['superior_department'].to_s.strip.presence
      begin
        dept = Department.find_by(name: name)
        if dept && superior_name.present?
          superior = Department.find_by(name: superior_name)
          if superior
            dept.update!(superior: superior)
          else
            puts "Line #{lineno}: superior department '#{superior_name}' not found"
          end
        end
      rescue => e
        errors << [lineno, e.message]
      end
    end

    puts "Departments import finished. Departments created/ensured: #{created.size}"
    if errors.any?
      puts "Errors (sample up to 20):"
      errors.first(20).each { |ln,msg| puts "Line #{ln}: #{msg}" }
    end
  end
end
