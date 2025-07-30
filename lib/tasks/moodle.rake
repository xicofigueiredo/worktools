namespace :moodle do
  desc "Sync Moodle user IDs with database users"
  task sync_user_ids: :environment do
    puts "Starting to sync Moodle user IDs..."

    service = MoodleApiService.new

    # Get all enrolled users from all courses
    all_moodle_users = Set.new

    # Get all courses without filtering
    courses = service.call('core_course_get_courses', {})

    if courses.is_a?(Array)
      puts "Found #{courses.size} courses in Moodle"

      # Get all users from each course
      courses.each do |course|
        begin
          course_users = service.get_enrolled_users(course['id'])
          if course_users.is_a?(Array)
            course_users.each do |user|
              all_moodle_users.add({
                moodle_id: user['id'],
                email: user['email'].downcase,
                name: user['fullname']
              })
            end
          end
        rescue => e
          puts "Error getting users for course #{course['id']}: #{e.message}"
        end
      end

      puts "\nFound #{all_moodle_users.size} unique Moodle users"

      # Now sync with our database
      updated_count = 0
      not_found_count = 0

      all_moodle_users.each do |moodle_user|
        user = User.find_by(email: moodle_user[:email].downcase)

        if user
          if user.moodle_id != moodle_user[:moodle_id]
            user.update(moodle_id: moodle_user[:moodle_id])
            updated_count += 1
            puts "Updated user #{user.email} with Moodle ID: #{moodle_user[:moodle_id]}"
          end
        else
          not_found_count += 1
          puts "Could not find user with email: #{moodle_user[:email]}"
        end
      end

      puts "\nSync completed!"
      puts "Updated #{updated_count} users with Moodle IDs"
      puts "#{not_found_count} Moodle users not found in database"
    else
      puts "Error fetching courses from Moodle"
    end
  end
end
