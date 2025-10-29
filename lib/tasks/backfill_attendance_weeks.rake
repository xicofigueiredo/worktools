namespace :data do
  desc "Backfill week_id for attendances based on attendance_date"
  task backfill_attendance_weeks: :environment do
    puts "Starting backfill of week_id for attendances..."
    
    updated_count = 0
    skipped_count = 0
    error_count = 0
    
    # Find all attendances
    Attendance.find_each do |attendance|
      begin
        # Skip if already has a valid week_id
        if attendance.week_id.present?
          week = Week.find_by(id: attendance.week_id)
          if week && attendance.attendance_date >= week.start_date && attendance.attendance_date <= week.end_date
            skipped_count += 1
            next
          end
        end
        
        # Find the matching week based on attendance_date
        matching_week = Week.where(
          "start_date <= ? AND end_date >= ?",
          attendance.attendance_date,
          attendance.attendance_date
        ).first
        
        if matching_week
          attendance.update_column(:week_id, matching_week.id)
          updated_count += 1
          puts "Updated attendance #{attendance.id} (date: #{attendance.attendance_date}) to week #{matching_week.id} (#{matching_week.name})"
        else
          puts "WARNING: Could not find matching week for attendance #{attendance.id} with date #{attendance.attendance_date}"
          error_count += 1
        end
      rescue => e
        puts "ERROR: Failed to process attendance #{attendance.id}: #{e.message}"
        error_count += 1
      end
    end
    
    puts "\nBackfill summary:"
    puts "  Updated: #{updated_count}"
    puts "  Skipped: #{skipped_count}"
    puts "  Errors: #{error_count}"
    puts "Done!"
  end
end

