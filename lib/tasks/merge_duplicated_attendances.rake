namespace :attendances do
  desc 'Deduplicate attendances'
  task merge_duplicated_attendances: :environment do
    puts "Starting deduplication process..."

    duplicates = Attendance
                 .select('user_id, attendance_date')
                 .group('user_id, attendance_date')
                 .having('COUNT(*) > 1')

    duplicates.each do |duplicate|
      user_id = duplicate.user_id
      date = duplicate.attendance_date
      records = Attendance.where(user_id:, attendance_date: date)

      merged_attributes = {}

      records.each do |record|
        record.attributes.each do |key, value|
          next if ['id', 'created_at', 'updated_at'].include?(key)

          merged_attributes[key] ||= value if value.present?
        end
      end

      records.each do |record|
        record.update!(merged_attributes)
        puts "updated attendance: #{record.id}"
      end
    end

    puts "Deduplication process completed."
  end
end
