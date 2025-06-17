class MoodleApiService
  def initialize
    @base_url = ENV['MOODLE_API_BASE_URL']
    @token    = ENV['MOODLE_API_TOKEN']
  end

  def call(function_name, params = {})
    base_params = {
      wstoken: @token,
      wsfunction: function_name,
      moodlewsrestformat: 'json'
    }.merge(params)

    # Flatten criteria if present
    if params[:criteria].is_a?(Array)
      params[:criteria].each_with_index do |criterion, idx|
        base_params["criteria[#{idx}][key]"]   = criterion[:key]
        base_params["criteria[#{idx}][value]"] = criterion[:value]
      end
      # Remove the original :criteria key so it doesn't get sent twice
      params.delete(:criteria)
    end

    # Merge any remaining top-level params (if you need other fields)
    base_params.merge!(params)

    # Use POST for complex or any multi-dimensional data
    response = RestClient.post(@base_url, base_params)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    { error: e.response }
  end

  def get_course_activities(course_id, user_id)
    response = call('local_wsbga_get_course', { courseid: course_id, userid: user_id })

    if response.is_a?(Array)
      response.map do |activity|
        {
          id: activity['id'],
          section_name: activity['section_name'],
          section_visible: activity['section_visible'],
          name: activity['name'],
          modname: activity['modname'],
          completion: activity['completion'],
          completiondata: activity['completiondata'],
          submission_date: activity['submission_date'],
          evaluation_date: activity['evaluation_date'],
          grade: activity['grade'],
          number_attempts: activity['number_attempts'],
          ect: activity['ect'],
          mock50: activity['mock50'],
          mock100: activity['mock100']
        }
      end
    else
      puts "Error fetching completed course activities: #{response}"
      []
    end
  end

  def create_timelines_for_learner(email)
    moodle_id = get_user_id(email)
    user_id = User.find_by(email: email).id
    return puts "User not found!" if user_id.nil?

    courses = get_user_courses(email) # Get enrolled courses
    return puts "No courses found!" if courses.empty?

    created_timelines = []
    courses.each do |course|
      course_id = course.split(":").first.to_i
      subject = Subject.find_by(moodle_id: course_id) # Extract Moodle ID and find the subject

      if subject
        timeline = Timeline.find_by(
          user_id: user_id,
          subject_id: subject.id,
        )
        if timeline.nil?
          timeline = Timeline.create!(
            user_id: user_id,
            subject_id: subject.id,
            start_date: Date.today,
            end_date: Date.today + 1.year,
            balance: 0,
            expected_progress: 0,
            progress: 0,
            total_time: 0,
            difference: 0
          )
        end

        created_timelines << timeline
        puts "Created #{timeline.subject.name} Timeline for #{course.split(':').last.strip}"

        # 🔹 Fetch and Create MoodleTopics for the Timeline using the new method 🔹
        completed_activities = get_course_activities(course_id, moodle_id)

        completed_activities.each_with_index do |activity, index|
          next if activity[:section_visible] == 0

          MoodleTopic.find_or_create_by!(
            timeline: timeline,
            time: activity[:ect].to_i || 1,  # Default to 1 if ect is nil or 0
            name: activity[:name],
            unit: activity[:section_name],  # Store section name as unit
            order: index + 1,  # Use index to maintain order
            grade: activity[:grade],  # Grade is already a number from the API
            done: activity[:completiondata] == 1,  # Mark as done if completed
            completion_date: begin
              if activity[:evaluation_date].present?
                DateTime.parse(activity[:evaluation_date])
              else
                nil
              end
            rescue Date::Error => e
              puts "Warning: Invalid date format for activity #{activity[:name]}: #{activity[:evaluation_date]}"
              nil
            end,
            moodle_id: activity[:id],
            deadline: Date.today + 1.year,  # Set a default deadline
            percentage: index * 0.001,
            mock50: activity[:mock50] == 1,
            mock100: activity[:mock100] == 1,
            number_attempts: activity[:number_attempts],
            submission_date: activity[:submission_date],
            evaluation_date: activity[:evaluation_date],
            completion_data: activity[:completiondata]
          )

          MoodleTopic.find_by(timeline: timeline, moodle_id: activity[:id]).update!(
            time: activity[:ect].to_i || 1,
            name: activity[:name],
            unit: activity[:section_name],
            order: index + 1,
            grade: activity[:grade],
            done: activity[:completiondata] == 1,
            completion_date: begin
              if activity[:evaluation_date].present?
                DateTime.parse(activity[:evaluation_date])
              else
                nil
              end
            rescue Date::Error => e
              puts "Warning: Invalid date format for activity #{activity[:name]}: #{activity[:evaluation_date]}"
              nil
            end,
            mock50: activity[:mock50] == 1,
            mock100: activity[:mock100] == 1,
            number_attempts: activity[:number_attempts],
            submission_date: activity[:submission_date],
            evaluation_date: activity[:evaluation_date],
            completion_data: activity[:completiondata]
          )
        end
      end
    end

    puts "✅ Created #{created_timelines.size} timelines for #{email}"
  end

  #create moodle timelines
  def create_moodle_timelines_for_learner(email)
    moodle_user_id = get_user_id(email)
    user_id = User.find_by(email: email).id
    return puts "User not found!" if user_id.nil?

    courses = get_user_courses(email) # Get enrolled courses
    return puts "No courses found!" if courses.empty?

    created_timelines = []
    courses.each do |course|
      course_id = course.split(":").first.to_i
      category = course.split(" ").last.to_i    # Gets "4" from the end of the string
      subject = Subject.find_by(moodle_id: course_id) # Extract Moodle ID and find the subject

      as1 = nil
      as2 = nil

      if category == 4
        as1 = true
        as2 = true
      end

      if subject
        moodle_timeline = MoodleTimeline.find_by(
          user_id: user_id,
          subject_id: subject.id,
        )

        if moodle_timeline.nil?
          moodle_timeline = MoodleTimeline.create!(
            user_id: user_id,
            subject_id: subject.id,
            start_date: Date.today,
            end_date: Date.today + 1.year,
            balance: 0,
            expected_progress: 0,
            progress: 0,
            total_time: 0,
            difference: 0,
            category: category,
            moodle_id: course_id,
            hidden: false,
            as1: as1,
            as2: as2
          )
        end

        # if course.id == 65
        #   MoodleTimeline.create!(
        #     user_id: user_id,
        #     subject_id: subject.id,
        #     start_date: Date.today,
        #     end_date: Date.today + 1.year,
        #     balance: 0,
        #     expected_progress: 0,
        #     progress: 0,
        #     total_time: 0,
        #     difference: 0,
        #     category: category,
        #     moodle_id: course_id,
        #     hidden: false,
        #     as1: nil,
        #     as2: nil
        #   )

        #   MoodleTimeline.create!(
        #     user_id: user_id,
        #     subject_id: subject.id,
        #     start_date: Date.today,
        #     end_date: Date.today + 1.year,
        #     balance: 0,
        #     expected_progress: 0,
        #     progress: 0,
        #     total_time: 0,
        #     difference: 0,
        #     category: category,
        #     moodle_id: course_id,
        #     hidden: false,
        #     as1: nil,
        #     as2: nil
        #   )

        #   MoodleTimeline.create!(
        #     user_id: user_id,
        #     subject_id: subject.id,
        #     start_date: Date.today,
        #     end_date: Date.today + 1.year,
        #     balance: 0,
        #     expected_progress: 0,
        #     progress: 0,
        #     total_time: 0,
        #     difference: 0,
        #     category: category,
        #     moodle_id: course_id,
        #     hidden: false,
        #     as1: nil,
        #     as2: nil
        #   )

        #   MoodleTimeline.create!(
        #     user_id: user_id,
        #     subject_id: subject.id,
        #     start_date: Date.today,
        #     end_date: Date.today + 1.year,
        #     balance: 0,
        #     expected_progress: 0,
        #     progress: 0,
        #     total_time: 0,
        #     difference: 0,
        #     category: category,
        #     moodle_id: course_id,
        #     hidden: false,
        #     as1: nil,
        #     as2: nil
        #   )
        # end

        created_timelines << moodle_timeline
        puts "Created #{moodle_timeline.subject.name} Moodle Timeline for #{course.split(':').last.strip}"

      end
    end

    puts "✅ Created #{created_timelines.size} timelines for #{email}"
  end

  def get_with_ect_activities
    # Define the category IDs we want to filter by
    target_categories = [3, 4, 5, 15, 18, 19, 33]

    # First, get all courses
    courses = call('core_course_get_courses', {})

    if courses.is_a?(Array)
      # Filter courses by category ID
      filtered_courses = courses.select { |course| target_categories.include?(course['categoryid'].to_i) }

      puts "\n📊 ECT Statistics for Selected Categories (#{target_categories.join(', ')}):"
      puts "================================================================="
      puts "Found #{filtered_courses.size} courses in selected categories"

      total_with_ect = 0
      total_without_ect = 0

      # Group courses by category for better organization
      courses_by_category = filtered_courses.group_by { |course| course['categoryid'] }

      courses_by_category.each do |category_id, category_courses|
        puts "\n📚 Category #{category_id}:"
        puts "------------------------"

        category_courses.each do |course|
          course_id = course['id']
          course_name = course['shortname']

          # Get activities for this course using an admin or manager user ID
          activities = get_course_activities(course_id, 2)

          if activities.is_a?(Array)
            with_ect = activities.count { |activity| activity[:ect].to_i > 0 }
            without_ect = activities.count { |activity| activity[:ect].to_i == 0 }

            total_with_ect += with_ect
            total_without_ect += without_ect

            puts "\n  Course: #{course_name} (ID: #{course_id})"
            puts "  - Activities with ECT: #{with_ect}"
            puts "  - Activities without ECT: #{without_ect}"
            puts "  - Total activities: #{activities.length}"
          end
        end
      end

      puts "\n📈 Overall Statistics:"
      puts "===================="
      puts "Total courses analyzed: #{filtered_courses.size}"
      puts "Total activities with ECT: #{total_with_ect}"
      puts "Total activities without ECT: #{total_without_ect}"
      puts "Total activities: #{total_with_ect + total_without_ect}"

      # Category breakdown
      puts "\n📊 Category Breakdown:"
      courses_by_category.each do |category_id, category_courses|
        category_total_activities = category_courses.sum do |course|
          activities = get_course_activities(course['id'], 2)
          activities.is_a?(Array) ? activities.length : 0
        end

        puts "Category #{category_id}:"
        puts "- Courses: #{category_courses.size}"
        puts "- Total activities: #{category_total_activities}"
      end
    else
      puts "Error fetching courses"
    end
  end

  # 1) Find a course by shortname
  def find_course_by_shortname(shortname)
    call('core_course_get_courses_by_field', { field: 'shortname', value: shortname })
  end

  # 2) Get enrolled users for a given course id
  def get_enrolled_users(course_id)
    call('core_enrol_get_enrolled_users', { courseid: course_id })
  end

  def get_all_courses
    a = []
    courses = call('core_course_get_courses', {})
    puts "Found #{courses.size} courses."

    # Group courses by category for better organization
    courses_by_category = courses.sort_by { |c| c['categoryid'] }.group_by { |c| c['categoryid'] }

    courses_by_category.each do |category_id, category_courses|
      puts "\nCategory #{category_id}:"
      puts "------------------------"
      category_courses.each do |course|
        a << " #{course['shortname']} #{course['id']} #{course['categoryid']}"
        # puts "#{course['id']}: #{course['fullname']} (#{course['shortname']})"
      end
    end
    puts a
    puts a.size

    # search Subjects with that name and populate subject.moodle_id with course['id']

  end

  # 4) Get user ID by email
  def get_user_id(email)
    response = call('core_user_get_users_by_field', { field: 'email', values: [email] })

    if response.is_a?(Array) && response.any?
      user = response.first
      puts "Found User ID: #{user['id']} - #{user['fullname']} (#{user['email']})"
      return user['id']
    else
      puts "User not found for email: #{email}"
      return nil
    end
  end


  # 5) Get enrolled courses for a given user ID
  def get_user_courses(email)
    user_id = get_user_id(email)
    return [] if user_id.nil?

    courses = call('core_enrol_get_users_courses', { userid: user_id, returnusercount: 0 })

    if courses.is_a?(Array) && courses.any?
      formatted_courses = courses.map do |course|
        "#{course['id']}: #{course['fullname']} (#{course['shortname']}) #{course['category']}"
      end

      puts formatted_courses.join("\n") # Print the formatted courses list
      return formatted_courses
    else
      puts "No enrolled courses found for #{email}!"
      return []
    end
  end

  #now i want to take a learner email and create those timelines for the courses they are enrolled that has a Subject with that moodle id

  # def create_timelines_for_learner(email)
  #   moodle_id = get_user_id(email)
  #   user_id = User.find_by(email: email).id
  #   return puts "User not found!" if user_id.nil?

  #   courses = get_user_courses(email) # Get enrolled courses
  #   return puts "No courses found!" if courses.empty?

  #   created_timelines = []

  #   courses.each do |course|
  #     subject = Subject.find_by(moodle_id: course.split(":").first.to_i) # Extract Moodle ID and find the subject

  #     if subject
  #       timeline = Timeline.find_or_create_by!(
  #         user_id: user_id,
  #         subject_id: subject.id,
  #         start_date: Date.today,
  #         end_date: Date.today + 1.year,
  #         balance: 0,
  #         expected_progress: 0,
  #         progress: 0,
  #         total_time: 0,
  #         difference: 0
  #       )
  #       created_timelines << timeline
  #       puts "Created #{timeline.subject.name} Timeline for #{course.split(':').last.strip}"

  #       # 🔹 Fetch and Create MoodleTopics for the Timeline 🔹
  #       course_topics = get_course_topics_for_learner(email, course.split(":").first.to_i)

  #       course_topics.each do |section|
  #         section[:activities].each_with_index do |activity, index|
  #             next if activity[:completion_date] == "N/A" || activity[:completion_date]== "N/A" || activity[:visible] == "Hidden" || activity[:completed] == "❓ Unknown"
  #             MoodleTopic.create!(
  #               timeline: timeline,
  #               time: 1,
  #               name: activity[:name],
  #               unit: section[:section],  # Store section name as unit
  #               order: index + 1,  # Use index to maintain order
  #               grade: activity[:grade] == "No Grade" ? nil : activity[:grade].to_f,  # Convert grade if available
  #               done: activity[:completed] == "✅ Done",  # Mark as done if completed
  #               completion_date: activity[:completion_date] == "N/A" ? nil : DateTime.parse(activity[:completion_date]),
  #               moodle_id: activity[:id],
  #               deadline: Date.today + 1.year,  # Set a default deadline
  #               percentage: index * 0.001
  #             )
  #         end
  #       end
  #     end
  #   end

  #   puts "✅ Created #{created_timelines.size} timelines for #{email}"
  # end


  # get all the topics for a specific course and learner
  def get_course_topics_for_learner(email, course_id)
    user_id = get_user_id(email)
    return puts "User not found!" if user_id.nil?

    # Fetch course contents (topics & activities)
    course_contents = call('core_course_get_contents', { courseid: course_id })

    # Fetch completion status for activities
    completion_status = call('core_completion_get_activities_completion_status', { courseid: course_id, userid: user_id })

    # Fetch grades for activities in the course
    grades_response = call('core_grades_get_gradeitems', { courseid: course_id })

    # Convert completion status into a hash for quick lookup
    completion_lookup = {}
    if completion_status["statuses"]
      completion_status["statuses"].each do |status|
        completion_lookup[status["cmid"]] = {
          completed: status["state"] == 1 ? "✅ Done" : "❌ Not Done",
          completion_date: status["timecompleted"] ? Time.at(status["timecompleted"]).strftime("%d %B %Y, %H:%M") : "N/A"
        }
      end
    end

    # Convert grades into a hash using cmid
    grades_lookup = {}
    if grades_response["gradeitems"]
      grades_response["gradeitems"].each do |grade|
        grades_lookup[grade["cmid"]] = {
          grade: grade["graderaw"] || "No Grade",
          max_grade: grade["grademax"] || "N/A"
        }
      end
    end

    if course_contents.is_a?(Array) && course_contents.any?
      course_topics = []

      course_contents.each do |section|
        next if section['name'].nil? || section['modules'].nil? # Skip empty sections

        section_title = section['name']
        section_visibility = section['visible'] == 1 ? " Visible" : "❌ Hidden"
        section_availability = section['availabilityinfo'] || "No restrictions"

        activities = section['modules'].map do |mod|
          activity_id = mod["id"]  # Capture the activity ID
          activity_visibility = mod['visible'] == 1 ? " Visible" : "❌ Hidden"
          activity_availability = mod['availabilityinfo'] || "No restrictions"

          # Get completion state and completion date
          completion_info = completion_lookup[activity_id] || { completed: "❓ Unknown", completion_date: "N/A" }

          # Check if the activity is completed and has a grade
          grade_info = grades_lookup[activity_id]
          grade_display = grade_info ? "#{grade_info[:grade]} / #{grade_info[:max_grade]}" : "No Grade"

          {
            id: activity_id,  # Added activity ID here
            name: mod['name'],
            visible: activity_visibility,
            availabilityinfo: activity_availability,
            completed: completion_info[:completed],
            completion_date: completion_info[:completion_date],  # Added completion date
            grade: completion_info[:completed] == "✅ Done" ? grade_display : "N/A",
          }
        end

        course_topics << {
          section: section_title,
          visible: section_visibility,
          availabilityinfo: section_availability,
          activities: activities
        }
      end

      return course_topics
    else
      puts "No topics or activities found for Course ID #{course_id}"
      return []
    end
  end


  def update_course_topics_for_learner(user, timeline)
    count = 0
    course_id = timeline.subject.moodle_id
    return { error: "No Moodle ID for subject!" } if course_id.nil?

    activities = get_course_activities(course_id, user.moodle_id)
    return { error: "No activities found for course!" } if activities.empty?

    updated_topics = []
    skipped_topics = []

    activities.each do |activity|
      next if activity[:section_visible] == 0

      mt = MoodleTopic.find_by(timeline: timeline, name: activity[:name])

      if mt
        begin
          updated_attributes = {
            done: activity[:completiondata] == 1,
            grade: activity[:grade],
            completion_date: begin
              if activity[:evaluation_date].present?
                DateTime.parse(activity[:evaluation_date])
              else
                nil
              end
            rescue Date::Error => e
              nil
            end,
            time: activity[:ect].to_i || 1,
            unit: activity[:section_name],
            mock50: activity[:mock50] == 1,
            mock100: activity[:mock100] == 1,
            number_attempts: activity[:number_attempts],
            submission_date: activity[:submission_date],
            evaluation_date: activity[:evaluation_date],
            completion_data: activity[:completiondata]
          }

          if mt.update(updated_attributes)
            count += 1
            updated_topics << {
              name: activity[:name],
              done: activity[:completiondata] == 1,
              ect: activity[:ect]
            }
          end
        rescue => e
          skipped_topics << { name: activity[:name], error: e.message }
        end
      end
    end

    {
      success: true,
      total_activities: activities.size,
      updated_count: count,
      updated_topics: updated_topics,
      skipped_topics: skipped_topics,
      timeline_id: timeline.id,
      course_id: course_id
    }
  end






















  # get the activities completion status of a course and a learner
  # def get_completion_status_for_learner(email, course_id)
  #   user_id = get_user_id(email)
  #   return puts "User not found!" if user_id.nil?

  #   completion_data = call('core_completion_get_activities_completion_status', { courseid: course_id, userid: user_id })

  #   # Ensure we have a valid response
  #   return puts "No completion data found!" if completion_data.nil? || completion_data["statuses"].nil?

  #   # Map Moodle completion states
  #   status_map = {
  #     0 => "❌ Not Completed",
  #     1 => "Completed",
  #     2 => "🎉 Completed (Passed)",
  #     3 => "⚠️ Completed (Failed)"
  #   }

  #   completion_results = {}

  #   completion_data["statuses"].each do |status|
  #     activity_id = status["cmid"]
  #     completion_results[activity_id] = status_map[status["state"]] || "❓ Unknown Status"
  #   end

  #   return completion_results
  # end

  # def get_grades_for_learner(email, course_id)
  #   user_id = get_user_id(email)
  #   return puts "User not found!" if user_id.nil?

  #   # Fetch grade items for the course
  #   grades_data = call('core_grades_get_gradeitems', { courseid: course_id })

  #   return puts "No grades found!" if grades_data.nil? || grades_data["gradeitems"].nil?

  #   grades = {}

  #   grades_data["gradeitems"].each do |item|
  #     # Handle cases where Moodle rejects 'itemname'
  #     clean_name = item["itemname"] rescue "Unnamed Item"

  #     grades[item["id"]] = {
  #       name: clean_name,
  #       max_grade: item["grademax"],
  #       min_grade: item["grademin"],
  #       grade_pass: item["gradepass"],
  #       aggregationcoef: item["aggregationcoef"], # Grade weight in final score
  #     }
  #   end

  #   return grades
  # end





  # def get_course_details_for_learner(email, course_id)
  #   topics = get_course_topics_for_learner(email, course_id)
  #   completion_status = get_completion_status_for_learner(email, course_id)
  #   grades = get_grades_for_learner(email, course_id)

  #   puts "📌 Course Overview for #{email} (Course ID: #{course_id}):"
  #   topics.each do |topic|
  #     puts "🔹 #{topic[:section]} (#{topic[:visible]})"
  #     topic[:activities].each do |activity|
  #       activity_status = completion_status[activity[:id]] || "❓ Unknown Status"
  #       activity_grade = grades[activity[:id]] || "No grade"
  #       puts "  - #{activity[:name]} (#{activity[:visible]})"
  #       puts "    ✔️ Status: #{activity_status}"
  #       puts "    📊 Grade: #{activity_grade}"
  #     end
  #   end
  # end



  # 6) Create user topics based on enrolled courses
  # def create_user_topics(email)
  #   user_id = get_user_id(email)
  #   return puts "User not found!" unless user_id

  #   courses = get_user_courses(email)
  #   return puts "No courses found!" if courses.empty?

  #   courses.each do |course|
  #     subject = Subject.find_or_create_by(moodle_id: course['shortname'])
  #     subject.update(moodle_id: course['id'])

  #     UserTopic.create!(
  #       user_id: user_id,
  #       subject_id: subject.id,
  #       moodle_course_id: course['id'],
  #       status: 'active'
  #     )
  #     puts "Created topic for #{course['shortname']} (#{course['id']})"
  #   end
  # end

  # service = MoodleApiService.new
  # courses = service.get_all_courses
  # francisco@bravegenerationacademy.com
  #lidia@bravegenerationacademy.com
  #I need to create user topics


end
