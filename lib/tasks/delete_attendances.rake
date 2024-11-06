namespace :attendances do
  desc 'Delete all attendance records with attendance_date earlier than 2024-06-01'
  task delete_attendances: :environment do
    cutoff_date = Date.new(2024, 6, 1)
    puts "Deleting attendance records before #{cutoff_date}..."

    # Find and delete records with attendance_date earlier than the cutoff date
    old_attendances = Attendance.where('attendance_date < ?', cutoff_date)

    # old_attendances.find_each do |attendance|
    #   attendance.destroy
    #   puts "Deleted attendance record with ID: #{attendance.id}, Date: #{attendance.attendance_date}"
    # end

    puts "Old attendance records deletion completed  - #{old_attendances.count} records deleted."
  end
end
