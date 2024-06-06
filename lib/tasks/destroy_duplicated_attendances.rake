namespace :attendances do
  desc 'Remove duplicate attendances, keeping the first created record'
  task remove_duplicates: :environment do
    puts "Starting duplicate removal process..."

    duplicates = Attendance
                   .select('user_id, attendance_date, COUNT(*) as count')
                   .group('user_id, attendance_date')
                   .having('count > 1')

    duplicates.each do |duplicate|
      user_id = duplicate.user_id
      date = duplicate.attendance_date
      records = Attendance.where(user_id: user_id, attendance_date: date).order(:created_at)

      records_to_destroy = records[1..]

      records_to_destroy.each do |record|
        record.destroy
        puts "Destroyed attendance record with ID: #{record.id}"
      end
    end

    puts "Duplicate removal process completed."
  end
end
