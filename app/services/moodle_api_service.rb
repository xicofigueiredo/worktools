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
    courses.each do |course|
      a << " #{course['shortname']} #{course['id']}"
      # puts "#{course['id']}: #{course['fullname']} (#{course['shortname']})"
    end
    puts a

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
        "#{course['id']}: #{course['fullname']} (#{course['shortname']})"
      end

      puts formatted_courses.join("\n") # Print the formatted courses list
      return formatted_courses
    else
      puts "No enrolled courses found for #{email}!"
      return []
    end
  end

  #now i want to take a learner email and create those timelines for the courses they are enrolled that has a Subject with that moodle id

  def create_timelines_for_learner(email)
    moodle_id = get_user_id(email)
    user_id = User.find_by(id: 811).id
    return puts "User not found!" if user_id.nil?

    courses = get_user_courses(email) # Get enrolled courses
    return puts "No courses found!" if courses.empty?

    created_timelines = []

    courses.each do |course|
      subject = Subject.find_by(moodle_id: course.split(":").first.to_i) # Extract Moodle ID and find the subject

      if subject
        timeline = Timeline.find_or_initialize_by(user_id: user_id, subject_id: subject.id)
        # Populate or update the fields
        timeline.start_date = Date.today
        timeline.end_date = Date.today + 1.year
        timeline.balance = 0
        timeline.expected_progress = 0
        timeline.progress = 0
        timeline.total_time = 0
        timeline.difference = 0
        timeline.save! # This will create or update as needed
        created_timelines << timeline
        puts "Created #{timeline.subject.name} Timeline for #{course.split(':').last.strip}"

        # 🔹 Fetch and Create MoodleTopics for the Timeline 🔹
        course_topics = get_course_topics_for_learner(email, course.split(":").first.to_i)

        # Keep track of the overall order
        overall_order = 0

        course_topics.each do |section|
          # Skip hidden sections or sections named "Hidden" or "To finish"
          next if section[:visible].include?("Hidden") ||
                  section[:section].include?("Hidden") ||
                  section[:section].include?("To finish") ||
                  section[:section].include?("For CM Only")

          section[:activities].each do |activity|
            next if activity[:completion_date] == "N/A" ||
                    activity[:visible] == "Hidden" ||
                    activity[:completed] == "❓ Unknown"

            overall_order += 1  # Increment order for each valid activity

            moodle_topic = MoodleTopic.find_or_initialize_by(
              timeline: timeline,
              moodle_id: activity[:id]
            )

            # Set or update attributes
            moodle_topic.time = 1
            moodle_topic.name = activity[:name]
            moodle_topic.unit = section[:section]
            moodle_topic.order = overall_order
            moodle_topic.grade = activity[:grade] == "No Grade" ? nil : activity[:grade].to_f
            moodle_topic.done = activity[:completed] == "✅ Done"
            moodle_topic.completion_date = activity[:completion_date] == "N/A" ? nil : DateTime.parse(activity[:completion_date])
            moodle_topic.deadline = Date.today + 1.year
            moodle_topic.percentage = overall_order * 0.01

            moodle_topic.save!
          end
        end
      end
    end

    puts "✅ Created #{created_timelines.size} timelines for #{email}"
  end


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

      # Sort sections by their 'section' field to maintain section order
      course_contents.sort_by { |section| section['section'].to_i }.each do |section|
        # SKIP hidden sections
        next if section['visible'] == 0
        next if section['name'].nil? || section['modules'].nil?

        section_title = section['name']
        section_visibility = section['visible'] == 1 ? " Visible" : "❌ Hidden"
        section_availability = section['availabilityinfo'] || "No restrictions"

        # Modules come in the correct order from the API, we'll preserve that order
        activities = section['modules'].each_with_index.map do |mod, index|
          activity_id = mod["id"]
          completion_info = completion_lookup[activity_id] || { completed: "❓ Unknown", completion_date: "N/A" }
          grade_info = grades_lookup[activity_id]
          grade_display = grade_info ? "#{grade_info[:grade]} / #{grade_info[:max_grade]}" : "No Grade"

          activity_visibility = mod['visible'] == 1 ? " Visible" : "❌ Hidden"

          {
            id: activity_id,
            name: mod['name'],
            visible: activity_visibility,
            availabilityinfo: mod['availabilityinfo'] || "No restrictions",
            completed: completion_info[:completed],
            completion_date: completion_info[:completion_date],
            grade: completion_info[:completed] == "✅ Done" ? grade_display : "N/A",
            order: index  # Using the index to preserve order
          }
        end

        course_topics << {
          section: section_title,
          section_number: section['section'].to_i,  # Add section number
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
    id = timeline.subject_id
    course_id = Subject.find(id).moodle_id
    return puts "No Moodle ID for subject!" if course_id.nil?

    # Fetch completion status for activities in the course
    completion_response = call('core_completion_get_activities_completion_status', { courseid: course_id, userid: 2245 })
    completion_lookup = {}
    if completion_response["statuses"]
      completion_response["statuses"].each do |status|
        completion_lookup[status["cmid"]] = {
          completed: status["state"] == 1,  # Moodle's state 1 means completed
          completion_date: status["timecompleted"] ? Time.at(status["timecompleted"]) : nil
        }
      end
    end
    # user = User.find_by(email: "francisco-abf@hotmail.com")
    # timeline = Timeline.find_by(user_id: user.id, subject_id: 100)


    # Fetch grades for activities in the course
    grades_response = call('core_grades_get_gradeitems', { courseid: course_id })
    grades_lookup = {}
    if grades_response["gradeitems"]
      grades_response["gradeitems"].each do |grade|
        grades_lookup[grade["cmid"]] = {
          grade: grade["graderaw"],
          max_grade: grade["grademax"]
        }
      end
    end

    # Update MoodleTopics in the given timeline
    timeline.moodle_topics.each do |topic|
      moodle_activity_id = topic.moodle_id  # Ensure this is the correct field

      if completion_lookup.key?(moodle_activity_id)
        completion_data = completion_lookup[moodle_activity_id]
        grade_data = grades_lookup[moodle_activity_id]

        updated_attributes = {}
        updated_attributes[:done] = completion_data[:completed] if topic.done != completion_data[:completed]
        updated_attributes[:completion_date] = completion_data[:completion_date] if topic.completion_date != completion_data[:completion_date]
        updated_attributes[:grade] = grade_data[:grade] if grade_data && topic.grade != grade_data[:grade]

        topic.update!(updated_attributes) unless updated_attributes.empty?
        count += 1
        puts "Checking completion for Moodle Topic ID #{topic.id}:"
        puts " - Existing Done: #{topic.done}, New Done: #{completion_data[:completed]}"
        puts " - Existing Date: #{topic.completion_date}, New Date: #{completion_data[:completion_date]}"
        puts " - Existing Grade: #{topic.grade}, New Grade: #{grade_data[:grade]}" if grade_data
      end


    end

    puts "✅ Updated #{count} Moodle topics for timeline ID #{timeline.id} (Course ID: #{course_id})"
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
