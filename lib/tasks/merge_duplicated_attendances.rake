namespace :attendances do
  desc 'Deduplicate attendances'
  task merge_duplicated_attendances: :environment do
    puts "Starting deduplication process..."

    duplicates = Attendance
                   .select('user_id, attendance_date, COUNT(*) as count')
                   .group('user_id, attendance_date')
                   .having('count > 1')

    duplicates.each do |duplicate|
      user_id = duplicate.user_id
      date = duplicate.attendance_date
      records = Attendance.where(user_id: user_id, attendance_date: date)

      merged_attributes = {}

      records.each do |record|
        record.attributes.each do |key, value|
          next if key == 'id' || key == 'created_at' || key == 'updated_at'

          if value.present?
            merged_attributes[key] ||= value
          end
        end
      end

      records.each do |record|
        record.update!(merged_attributes)
      end
    end

    puts "Deduplication process completed."
  end
end
