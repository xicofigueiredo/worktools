class MoodleApiService
  def initialize
    @base_url = ENV['MOODLE_API_BASE_URL']
    @token    = ENV['MOODLE_API_TOKEN']
    # Simple in-memory cache with 5-minute expiration
    @cache = {}
    @cache_duration = 0.minutes
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

  def get_all_course_activities(course_id, user_id)
    # Use the custom API that includes ECT values (similar to get_all_course_activities)
    response = call('local_wsbga_get_course', { courseid: course_id, userid: user_id })
    total_ect = 0
    activities_with_ect = 0
    activities_without_ect = 0

    if response.is_a?(Array)
      all_activities = []

      response.each do |activity|
        ect_value = activity['ect'].to_f
        total_ect += ect_value

        if ect_value > 0
          activities_with_ect += 1
        else
          activities_without_ect += 1
        end

        all_activities << {
          id: activity['id'],
          section_name: activity['section_name'],
          section_visible: activity['section_visible'],
          name: activity['name'],
          modname: activity['modname'],
          ect: ect_value,
          visible: activity['visible'] == 1,
          availabilityinfo: activity['availabilityinfo'] || "No restrictions",
          description: activity['description'] || "",
          url: activity['url'] || "",
          completiondata: activity['completiondata'],
          mock50: activity['mock50'],
          mock100: activity['mock100'],
          number_attempts: activity['number_attempts'],
          submission_date: activity['submission_date'],
          evaluation_date: activity['evaluation_date'],
          grade: activity['grade'],
          ect: activity['ect']

        }
      end

      puts "Found #{all_activities.length} activities in course #{course_id}"
      puts "Total ECTs: #{total_ect}"
      puts "Activities with ECT: #{activities_with_ect}"
      puts "Activities without ECT: #{activities_without_ect}"

      all_activities
    else
      puts "Error fetching course activities: #{response}"
      []
    end
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

  #create moodle timelines
  def create_moodle_timelines_for_learner(email)
    moodle_user_id = get_user_id(email)
    user = User.find_by(email: email)
    user_id = user.id
    user.moodle_id = moodle_user_id
    user.save!
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
      elsif category == 19 # Year 7
        moodle_timeline = MoodleTimeline.find_or_create_by(
          user_id: user_id,
          subject_id: 1007
        ) do |mt|
          mt.start_date = Date.today + 1.day
          mt.end_date = Date.today + 1.year
          mt.category = category
          mt.hidden = false
          mt.balance = 0
          mt.expected_progress = 0
          mt.progress = 0
          mt.total_time = 0
          mt.difference = 0
        end

        # Create one MoodleTopic per relevant course section (LTR, English, Maths, Science)
        desired_sections = ["Learning Through Research", "English", "Mathematics", "Science"]
        sections = []
        begin
          sections = get_course_topics_for_learner(email, course_id)
        rescue => e
          Rails.logger.warn "Could not fetch sections for course #{course_id}: #{e.message}"
        end

        # Derive unit name from the course string: take the main course title and drop the leading "Year X - " prefix
        main_title = course.split(":", 2)[1].to_s.strip
        main_title = main_title.split("(").first.to_s.strip
        unit_name = main_title.sub(/^Year\s*\d+\s*-\s*/, '').strip

        order_counter = 0
        sections.each do |section|
          section_name = section[:section].to_s.strip
          next if section_name.blank?
          next unless desired_sections.include?(section_name)

          order_counter += 1
          topic = moodle_timeline.moodle_topics.find_or_initialize_by(name: section_name, unit: unit_name)
          topic.order = order_counter
          topic.done = false if topic.done.nil?
          topic.deadline = moodle_timeline.end_date
          topic.time = 1 if topic.time.blank?
          topic.save!
        end
      elsif category == 18 # Year 8
        moodle_timeline = MoodleTimeline.find_or_create_by(
          user_id: user_id,
          subject_id: 1008
        ) do |mt|
          mt.start_date = Date.today + 1.day
          mt.end_date = Date.today + 1.year
          mt.category = category
          mt.hidden = false
          mt.balance = 0
          mt.expected_progress = 0
          mt.progress = 0
          mt.total_time = 0
          mt.difference = 0
        end

        # Create one MoodleTopic per relevant course section (LTR, English, Maths, Science)
        desired_sections = ["Learning Through Research", "English", "Mathematics", "Science"]
        sections = []
        begin
          sections = get_course_topics_for_learner(email, course_id)
        rescue => e
          Rails.logger.warn "Could not fetch sections for course #{course_id}: #{e.message}"
        end

        # Derive unit name from the course string: take the main course title and drop the leading "Year X - " prefix
        main_title = course.split(":", 2)[1].to_s.strip
        main_title = main_title.split("(").first.to_s.strip
        unit_name = main_title.sub(/^Year\s*\d+\s*-\s*/, '').strip

        order_counter = 0
        sections.each do |section|
          section_name = section[:section].to_s.strip
          next if section_name.blank?
          next unless desired_sections.include?(section_name)

          order_counter += 1
          topic = moodle_timeline.moodle_topics.find_or_initialize_by(name: section_name, unit: unit_name)
          topic.order = order_counter
          topic.done = false if topic.done.nil?
          topic.deadline = moodle_timeline.end_date
          topic.time = 1 if topic.time.blank?
          topic.save!
        end
      elsif category == 33 # Year 9
        moodle_timeline = MoodleTimeline.find_or_create_by(
          user_id: user_id,
          subject_id: 1009
        ) do |mt|
          mt.start_date = Date.today + 1.day
          mt.end_date = Date.today + 1.year
          mt.category = category
          mt.hidden = false
          mt.balance = 0
          mt.expected_progress = 0
          mt.progress = 0
          mt.total_time = 0
          mt.difference = 0
        end

        # Create one MoodleTopic per relevant course section (LTR, English, Maths, Science)
        desired_sections = ["Learning Through Research", "English", "Mathematics", "Science"]
        sections = []
        begin
          sections = get_course_topics_for_learner(email, course_id)
        rescue => e
          Rails.logger.warn "Could not fetch sections for course #{course_id}: #{e.message}"
        end

        # Derive unit name from the course string: take the main course title and drop the leading "Year X - " prefix
        main_title = course.split(":", 2)[1].to_s.strip
        main_title = main_title.split("(").first.to_s.strip
        unit_name = main_title.sub(/^Year\s*\d+\s*-\s*/, '').strip

        order_counter = 0
        sections.each do |section|
          section_name = section[:section].to_s.strip
          next if section_name.blank?
          next unless desired_sections.include?(section_name)

          order_counter += 1
          topic = moodle_timeline.moodle_topics.find_or_initialize_by(name: section_name, unit: unit_name)
          topic.order = order_counter
          topic.done = false if topic.done.nil?
          topic.deadline = moodle_timeline.end_date
          topic.time = 1 if topic.time.blank?
          topic.save!
        end
      end

      if subject
        moodle_timeline = MoodleTimeline.find_by(
          user_id: user_id,
          subject_id: subject.id,
        )
        timeline = Timeline.find_by(
          user_id: user_id,
          subject_id: subject.id,
        )
        if timeline.nil?
          start_date = Date.today
          end_date = Date.today + 1.year
          exam_date_id = nil
        else
          start_date = timeline.start_date.present? ? timeline.start_date : Date.today
          end_date = timeline.end_date.present? ? timeline.end_date : Date.today + 1.year
          exam_date_id = timeline.exam_date_id
        end

        if moodle_timeline.nil?
          begin
            moodle_timeline = MoodleTimeline.create!(
              user_id: user_id,
              subject_id: subject.id,
              start_date: start_date,
              end_date: end_date,
              exam_date_id: exam_date_id,
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
          rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
            # If a duplicate was created by a race condition, find the existing one
            moodle_timeline = MoodleTimeline.find_by(user_id: user_id, subject_id: subject.id)
            if moodle_timeline.nil?
              # If it still doesn't exist, re-raise the original error
              raise e
            else
              puts "Found existing timeline for user #{user_id} and subject #{subject.id}"
            end
          end
        end

        created_timelines << moodle_timeline
        puts "Created #{moodle_timeline.subject.name} Moodle Timeline for #{course.split(':').last.strip}"
      end
    end

    puts "✅ Created #{created_timelines.size} timelines for #{email}"
  end

  def get_with_ect_activities
    # Define the category IDs we want to filter by
    target_categories = [35, 45, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57]

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

          begin
            # Get activities with ECT data using custom API (admin user ID = 2)
            completed_activities = get_all_course_activities(course_id, 2)

            # Enrich missing ids (cmid) by name using core_course_get_contents
            if completed_activities.any? { |a| a[:id].nil? }
              begin
                contents = call('core_course_get_contents', { courseid: course_id })
                modules = Array(contents).flat_map { |s| s['modules'] || [] }
                name_to_cmid = {}
                modules.each { |m| n = m['name']; name_to_cmid[n] ||= m['id'] if n }
                completed_activities.each { |a| a[:id] ||= name_to_cmid[a[:name]] }
              rescue => e
                puts "    Warning: Could not enrich moodle ids for course #{course_id}: #{e.message}"
              end
            end

            if completed_activities.is_a?(Array)
              with_ect = completed_activities.count { |activity| activity[:ect].to_f > 0 }
              without_ect = completed_activities.count { |activity| activity[:ect].to_f == 0 }
              total_ect = completed_activities.sum { |activity| activity[:ect].to_f }

              total_with_ect += with_ect
              total_without_ect += without_ect

              puts "\n  Course: #{course_name} (ID: #{course_id})"
              puts "  - Activities with ECT: #{with_ect}"
              puts "  - Activities without ECT: #{without_ect}"
              puts "  - Total activities: #{completed_activities.length}"
              puts "  - Total ECT: #{total_ect}"

              # Show activities with missing IDs after enrichment
              missing_ids = completed_activities.count { |a| a[:id].nil? }
              if missing_ids > 0
                puts "  - Activities with missing IDs: #{missing_ids}"
              end
            end

          rescue => e
            puts "\n  ❌ Error processing course #{course_name} (ID: #{course_id}): #{e.message}"
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
          begin
            activities = get_all_course_activities(course['id'], 2)
            activities.is_a?(Array) ? activities.length : 0
          rescue
            0
          end
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

    target_categories = [3, 4, 5, 15, 18, 19, 33]

    # Filter and group courses by target categories only
    courses_by_category = courses.select { |c| target_categories.include?(c['categoryid']) }
                                .sort_by { |c| [c['categoryid'], c['shortname']] }
                                .group_by { |c| c['categoryid'] }

    # Sort categories by ID
    target_categories.sort.each do |category_id|
      next unless courses_by_category[category_id]
      puts "\nCategory #{category_id}:"
      puts "------------------------"
      courses_by_category[category_id].each do |course|
        a << "#{course['shortname']} #{course['id']} #{course['categoryid']}"
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



  def update_course_topics_for_learner(user, timeline)
    count = 0
    course_id = timeline.subject.moodle_id
    return { error: "No Moodle ID for subject!" } if course_id.nil?

    activities = get_course_topics_for_learner(user.email, course_id)
    return { error: "No activities found for course!" } if activities.empty?

    # Build an index by moodle_id for fast exact matching
    existing_topics_by_moodle_id = timeline.moodle_topics.index_by(&:moodle_id)

    updated_topics = []
    skipped_topics = []

    activities.each do |activity|
      next if activity[:section_visible] == 0 || activity[:ect] ==  0

      # Prefer exact id match; fallback to name for both timeline types
      mt = existing_topics_by_moodle_id[activity[:id]]
      if mt.nil?
        mt = if defined?(MoodleTimeline) && timeline.is_a?(MoodleTimeline)
          MoodleTopic.find_by(moodle_timeline: timeline, name: activity[:name])
        else
          MoodleTopic.find_by(timeline: timeline, name: activity[:name])
        end
      end

      if mt
        begin
          updated_attributes = {
            done: (activity[:completiondata].to_i == 1 || activity[:completiondata].to_i == 2),
            grade: activity[:grade],
            completion_date: begin
              ed = activity[:evaluation_date]
              if ed.present?
                if ed.is_a?(Numeric) || ed.to_s =~ /\A\d+\z/
                  Time.at(ed.to_i).to_datetime
                else
                  DateTime.parse(ed)
                end
              else
                nil
              end
            rescue
              nil
            end,
            time: activity[:ect].to_f || 1,
            unit: activity[:section_name],
            mock50: activity[:mock50].to_i == 1,
            mock100: activity[:mock100].to_i == 1,
            number_attempts: activity[:number_attempts],
            submission_date: activity[:submission_date],
            evaluation_date: activity[:evaluation_date],
            completion_data: activity[:completiondata]
          }

          # Backfill moodle_id if missing on the local record
          updated_attributes[:moodle_id] = activity[:id] if mt.moodle_id.blank? && activity[:id].present?

          if mt.update(updated_attributes)
            count += 1
            updated_topics << {
              name: activity[:name],
              done: (activity[:completiondata].to_i == 1 || activity[:completiondata].to_i == 2),
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

  # Get assignments for a course using the standard Moodle API (similar to your working client)
  def fetch_course_assignments(course_id)
    puts "📋 Fetching assignments for course #{course_id} using standard API..."

    params = { 'courseids[0]' => course_id }
    data = call('mod_assign_get_assignments', params)

    assignments = data.dig('courses', 0, 'assignments') || []

    puts "Found #{assignments.size} assignments"
    assignments
  end

  # Get assignment by cmid (course module id)
  def fetch_assignment_by_cmid(course_id, cmid)
    assignments = fetch_course_assignments(course_id)
    assignments.find { |a| a['cmid'] == cmid.to_i }
  end

  # Get submission status for a specific assignment and user
  def fetch_submission_status(assignment_id, user_id)
    params = { 'assignid' => assignment_id, 'userid' => user_id }
    call('mod_assign_get_submission_status', params)
  end

  # Get user info by user ID
  def fetch_user_info(user_id)
    params = { 'field' => 'id', 'values[0]' => user_id }
    data = call('core_user_get_users_by_field', params)

    return nil unless data.is_a?(Array) && data.any?

    user = data.first
    {
      id: user["id"],
      email: user["email"],
      name: "#{user['firstname']} #{user['lastname']}",
      firstname: user['firstname'],
      lastname: user['lastname']
    }
  rescue => e
    puts "Failed to fetch user info for user ##{user_id}: #{e.message}"
    nil
  end

  # Get detailed assignment information for a course
  def get_course_assignments_detailed(course_id)
    puts "📋 Getting detailed assignment info for course #{course_id}..."

    # Get basic assignment info
    assignments = fetch_course_assignments(course_id)
    return [] if assignments.empty?

    detailed_assignments = []

    assignments.each do |assignment|
      assignment_info = {
        id: assignment['id'],
        cmid: assignment['cmid'],
        name: assignment['name'],
        course_id: course_id,
        due_date: assignment['duedate'] > 0 ? Time.at(assignment['duedate']).strftime("%d %B %Y, %H:%M") : "No due date",
        cutoff_date: assignment['cutoffdate'] > 0 ? Time.at(assignment['cutoffdate']).strftime("%d %B %Y, %H:%M") : "No cutoff",
        allow_submissions_from: assignment['allowsubmissionsfromdate'] > 0 ? Time.at(assignment['allowsubmissionsfromdate']).strftime("%d %B %Y, %H:%M") : "No start date",
        max_grade: assignment['grade'],
        max_attempts: assignment['maxattempts'],
        intro: assignment['intro'],
        submissions: []
      }

      puts "  📝 Processing assignment: #{assignment['name']}"
      detailed_assignments << assignment_info
    end

    detailed_assignments
  end
  # Get assignment submissions for all learners in a course
  def get_course_assignment_submissions(course_id)
    puts "📋 Getting assignment submissions for all learners in course #{course_id}..."

    # Get assignments
    assignments = fetch_course_assignments(course_id)
    return [] if assignments.empty?

    # Get enrolled users
    enrolled_users = get_enrolled_users(course_id)
    return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

    all_submissions = []

    assignments.each do |assignment|
      assignment_id = assignment['id']
      assignment_name = assignment['name']

      puts "  📝 Processing assignment: #{assignment_name}"

      enrolled_users.each do |user|
        user_id = user['id']
        user_name = user['fullname']
        user_email = user['email']

        # Get submission status for this user and assignment
        submission_data = fetch_submission_status(assignment_id, user_id)

        if submission_data && submission_data['lastattempt']
          attempt = submission_data['lastattempt']
          submission = attempt['submission'] || attempt['teamsubmission']
          feedback = submission_data['feedback']

          submission_info = {
            assignment_id: assignment_id,
            assignment_name: assignment_name,
            cmid: assignment['cmid'],
            learner_id: user_id,
            learner_name: user_name,
            learner_email: user_email,
            course_id: course_id,

            # Submission data
            submission_status: submission ? submission['status'] : 'No submission',
            submission_date: submission && submission['timecreated'] > 0 ? Time.at(submission['timecreated']).strftime("%d %B %Y, %H:%M") : 'Not submitted',
            last_modified: submission && submission['timemodified'] > 0 ? Time.at(submission['timemodified']).strftime("%d %B %Y, %H:%M") : 'N/A',
            attempt_number: submission ? submission['attemptnumber'] + 1 : 0,

            # Feedback data
            grade: feedback && feedback['grade'] ? feedback['grade']['grade'].to_f : 0,
            grade_display: feedback ? feedback['gradefordisplay'] : 'No grade',
            feedback_date: feedback && feedback['grade'] && feedback['grade']['timemodified'] > 0 ? Time.at(feedback['grade']['timemodified']).strftime("%d %B %Y, %H:%M") : 'No feedback',
            graded_date: feedback && feedback['gradeddate'] > 0 ? Time.at(feedback['gradeddate']).strftime("%d %B %Y, %H:%M") : 'Not graded',

            # Assignment details
            due_date: assignment['duedate'] > 0 ? Time.at(assignment['duedate']).strftime("%d %B %Y, %H:%M") : "No due date",
            max_grade: assignment['grade'],
            max_attempts: assignment['maxattempts']
          }

          # Extract feedback comments
          if feedback && feedback['plugins']
            comments = []
            feedback['plugins'].each do |plugin|
              if plugin['type'] == 'comments' && plugin['editorfields']
                plugin['editorfields'].each do |field|
                  if field['name'] == 'comments' && field['text'].present?
                    comments << field['text']
                  end
                end
              end
            end
            submission_info[:feedback_comments] = comments.join('; ')
          end

          all_submissions << submission_info
        end
      end
    end

    all_submissions
  end

def get_organized_assignment_data(course_id)
  puts "📋 Getting organized assignment submission data for course #{course_id}..."

  # Get all assignments for the course
  assignments = fetch_course_assignments(course_id)
  return [] if assignments.empty?

  # Get all enrolled users
  enrolled_users = get_enrolled_users(course_id)
  return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

  organized_data = []

  assignments.each do |assignment|
    assignment_id = assignment['id']
    assignment_name = assignment['name']

    puts "  📝 Processing assignment: #{assignment_name}"

    enrolled_users.each do |user|
      user_id = user['id']
      user_name = user['fullname']
      user_email = user['email']

      # Get submission status for this user and assignment
      submission_data = fetch_submission_status(assignment_id, user_id)

      if submission_data && submission_data['lastattempt']
        # Get all attempts by calling the submissions API
        attempts_data = []

        begin
          # Try to get all submissions for this assignment
          all_submissions_response = call('mod_assign_get_submissions', { assignmentids: [assignment_id] })

          if all_submissions_response['assignments']&.any?
            assignment_submissions = all_submissions_response['assignments'].find { |a| a['assignmentid'] == assignment_id }

            if assignment_submissions && assignment_submissions['submissions']
              user_submissions = assignment_submissions['submissions'].select { |s| s['userid'] == user_id }

              # Sort by attempt number
              user_submissions.sort_by! { |s| s['attemptnumber'] }

              user_submissions.each do |submission|
                attempt_number = submission['attemptnumber'] + 1

                # Get detailed feedback for this specific attempt
                attempt_feedback = get_attempt_feedback(assignment_id, user_id, submission['attemptnumber'])

                attempts_data << {
                  attempt_number: attempt_number,
                  submission_date: submission['timecreated'] > 0 ? Time.at(submission['timecreated']).strftime("%d %B %Y, %H:%M") : 'Not submitted',
                  last_modified: submission['timemodified'] > 0 ? Time.at(submission['timemodified']).strftime("%d %B %Y, %H:%M") : 'N/A',
                  status: submission['status'],
                  feedback_date: attempt_feedback[:feedback_date],
                  grade: attempt_feedback[:grade],
                  grade_display: attempt_feedback[:grade_display],
                  feedback_comments: attempt_feedback[:comments]
                }
              end
            end
          end
        rescue => e
          puts "    Warning: Could not fetch all attempts for assignment #{assignment_id}: #{e.message}"
          # Fallback to using the latest attempt data
          attempt = submission_data['lastattempt']
          submission = attempt['submission'] || attempt['teamsubmission']
          feedback = submission_data['feedback']

          if submission
            attempts_data << {
              attempt_number: submission['attemptnumber'] + 1,
              submission_date: submission['timecreated'] > 0 ? Time.at(submission['timecreated']).strftime("%d %B %Y, %H:%M") : 'Not submitted',
              last_modified: submission['timemodified'] > 0 ? Time.at(submission['timemodified']).strftime("%d %B %Y, %H:%M") : 'N/A',
              status: submission['status'],
              feedback_date: feedback && feedback['grade'] && feedback['grade']['timemodified'] > 0 ? Time.at(feedback['grade']['timemodified']).strftime("%d %B %Y, %H:%M") : 'No feedback',
              grade: feedback && feedback['grade'] ? feedback['grade']['grade'].to_f : 0,
              grade_display: feedback ? feedback['gradefordisplay'] : 'No grade',
              feedback_comments: extract_feedback_comments(feedback)
            }
          end
        end

        # Create organized record
        organized_record = {
          assignment_id: assignment_id,
          assignment_name: assignment_name,
          learner_id: user_id,
          learner_name: user_name,
          learner_email: user_email,
          course_id: course_id,
          due_date: assignment['duedate'] > 0 ? Time.at(assignment['duedate']).strftime("%d %B %Y, %H:%M") : "No due date",
          max_grade: assignment['grade'],
          max_attempts: assignment['maxattempts'],
          total_attempts: attempts_data.size,

          # Organized attempt data
          first_submission_date: attempts_data.first&.dig(:submission_date) || 'Not submitted',
          first_feedback_date: attempts_data.first&.dig(:feedback_date) || 'No feedback',
          first_grade: attempts_data.first&.dig(:grade) || 0,

          second_submission_date: attempts_data[1]&.dig(:submission_date) || 'No resubmission',
          second_feedback_date: attempts_data[1]&.dig(:feedback_date) || 'No 2nd feedback',
          second_grade: attempts_data[1]&.dig(:grade) || 0,

          # Keep all attempts for reference
          all_attempts: attempts_data
        }

        organized_data << organized_record
      end
    end
  end

  puts "✅ Organized data for #{organized_data.size} submission records"
  organized_data
end

# Helper method to extract feedback comments
def extract_feedback_comments(feedback)
  return 'No feedback' unless feedback && feedback['plugins']

  comments = []
  feedback['plugins'].each do |plugin|
    if plugin['type'] == 'comments' && plugin['editorfields']
      plugin['editorfields'].each do |field|
        if field['name'] == 'comments' && field['text'].present?
          comments << field['text']
        end
      end
    end
  end

  comments.any? ? comments.join('; ') : 'No feedback comments'
end

# Helper method to get feedback for a specific attempt
def get_attempt_feedback(assignment_id, user_id, attempt_number)
  submission_data = fetch_submission_status(assignment_id, user_id)

  if submission_data && submission_data['feedback'] && submission_data['feedback']['grade']
    grade_info = submission_data['feedback']['grade']

    # Check if this feedback is for the specific attempt
    if grade_info['attemptnumber'] == attempt_number
      {
        feedback_date: grade_info['timemodified'] > 0 ? Time.at(grade_info['timemodified']).strftime("%d %B %Y, %H:%M") : 'No feedback',
        grade: grade_info['grade'].to_f,
        grade_display: submission_data['feedback']['gradefordisplay'] || 'No grade',
        comments: extract_feedback_comments(submission_data['feedback'])
      }
    else
      {
        feedback_date: 'No feedback',
        grade: 0,
        grade_display: 'No grade',
        comments: 'No feedback'
      }
    end
  else
    {
      feedback_date: 'No feedback',
      grade: 0,
      grade_display: 'No grade',
      comments: 'No feedback'
    }
  end
end

  # Create a summary table format
  def create_assignment_summary_table(course_id)
    data = get_organized_assignment_data(course_id)

    puts "\n📊 ASSIGNMENT SUBMISSION SUMMARY - Course #{course_id}"
    puts "=" * 120
    printf "%-30s %-20s %-15s %-15s %-8s %-15s %-15s %-8s\n",
          "Assignment", "Learner", "1st Submission", "1st Feedback", "1st Grade", "2nd Submission", "2nd Feedback", "2nd Grade"
    puts "=" * 120

    data.each do |record|
      printf "%-30s %-20s %-15s %-15s %-8s %-15s %-15s %-8s\n",
            record[:assignment_name][0..29],
            record[:learner_name][0..19],
            record[:first_submission_date][0..14],
            record[:first_feedback_date][0..14],
            record[:first_grade],
            record[:second_submission_date][0..14],
            record[:second_feedback_date][0..14],
            record[:second_grade]
    end

    puts "=" * 120
    puts "Total records: #{data.size}"

    data
  end

  def get_quick_assignment_sample(course_id, max_assignments: 10, max_users: 50)
    puts "📋 Getting sample assignment data for course #{course_id}..."

    assignments = fetch_course_assignments(course_id)
    enrolled_users = get_enrolled_users(course_id)

    return [] if assignments.empty? || enrolled_users.empty?

    # Limit to specified number of assignments and users
    sample_assignments = assignments.first(max_assignments)
    sample_users = enrolled_users.first(max_users)

    puts "Processing #{sample_assignments.size} assignments with #{sample_users.size} users"

    results = []

    sample_assignments.each do |assignment|
      assignment_id = assignment['id']
      assignment_name = assignment['name']

      puts "  📝 Processing: #{assignment_name}"

      sample_users.each do |user|
        user_id = user['id']
        user_name = user['fullname']

        submission_data = fetch_submission_status(assignment_id, user_id)

        if submission_data && submission_data['lastattempt']
          attempt = submission_data['lastattempt']
          submission = attempt['submission'] || attempt['teamsubmission']
          feedback = submission_data['feedback']

          result = {
            assignment_name: assignment_name,
            learner_name: user_name,
            learner_email: user['email'],
            submission_date: submission ? (submission['timecreated'] > 0 ? Time.at(submission['timecreated']).strftime("%d %B %Y, %H:%M") : 'Not submitted') : 'No submission',
            feedback_date: feedback && feedback['grade'] && feedback['grade']['timemodified'] > 0 ? Time.at(feedback['grade']['timemodified']).strftime("%d %B %Y, %H:%M") : 'No feedback',
            grade: feedback && feedback['grade'] ? feedback['grade']['grade'].to_f : 0,
            attempts: submission ? submission['attemptnumber'] + 1 : 0
          }

          results << result
        end
      end
    end

    results
  end

  # Add this method - it uses your working custom API instead of the assignment API
  def get_assignments_from_activities(course_id, max_users: 50)
    puts "📋 Getting assignments from activities for course #{course_id}..."

    # Get enrolled users
    enrolled_users = get_enrolled_users(course_id)
    return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

    # Limit users for performance
    sample_users = enrolled_users.first(max_users)

    all_results = []

    sample_users.each do |user|
      user_id = user['id']
      user_name = user['fullname']
      user_email = user['email']

      puts "  Processing user: #{user_name}"

      # Use your working custom API
      activities = get_all_course_activities(course_id, user_id)

      # Filter for assignment-like activities
      assignments = activities.select do |activity|
        activity[:submission_date].present? ||
        activity[:evaluation_date].present? ||
        activity[:name].downcase.include?('assignment') ||
        activity[:name].downcase.include?('essay') ||
        activity[:name].downcase.include?('project') ||
        activity[:name].downcase.include?('mock') ||
        (activity[:grade]&.to_f || 0) > 0 ||
        (activity[:number_attempts]&.to_i || 0) > 0
      end

      assignments.each do |assignment|
        all_results << {
          assignment_name: assignment[:name],
          learner_name: user_name,
          learner_email: user_email,
          submission_date: assignment[:submission_date].present? ? assignment[:submission_date] : 'No submission',
          feedback_date: assignment[:evaluation_date].present? ? assignment[:evaluation_date] : 'No feedback',
          grade: (assignment[:grade]&.to_f || 0),
          attempts: (assignment[:number_attempts]&.to_i || 0),
          section_name: assignment[:section_name],
          ect: assignment[:ect],
          completion_status: assignment[:completiondata] == 1 ? "Completed" : "Not Completed"
        }
      end
    end

    puts "Found #{all_results.size} assignment records"
    all_results
  end

# Test which courses actually work with our APIs
def test_course_access(course_ids = [1, 2, 107, 128, 149])
  puts "🔍 Testing course access..."

  working_courses = []

  course_ids.each do |course_id|
    puts "\n--- Testing Course #{course_id} ---"

    # Test 1: Check if course exists
    begin
      enrolled_users = get_enrolled_users(course_id)
      puts "✅ Course #{course_id}: #{enrolled_users.size} enrolled users"

      # Test 2: Check assignment API
      begin
        assignments = fetch_course_assignments(course_id)
        puts "✅ Assignment API: #{assignments.size} assignments found"
      rescue => e
        puts "❌ Assignment API failed: #{e.message}"
        assignments = []
      end

      # Test 3: Check custom API with admin user (ID 2)
      begin
        activities = get_all_course_activities(course_id, 2)
        puts "✅ Custom API (admin): #{activities.size} activities found"

        # Fixed nil handling
        assignment_like = activities.select do |activity|
          activity[:submission_date].present? ||
          activity[:evaluation_date].present? ||
          (activity[:grade]&.to_f || 0) > 0  # Safe nil handling
        end
        puts "✅ Assignment-like activities: #{assignment_like.size}"

        working_courses << {
          course_id: course_id,
          enrolled_users: enrolled_users.size,
          assignments: assignments.size,
          activities: activities.size,
          assignment_activities: assignment_like.size
        }

      rescue => e
        puts "❌ Custom API failed: #{e.message}"
      end

    rescue => e
      puts "❌ Course #{course_id} not accessible: #{e.message}"
    end
  end

  puts "\n📊 Working Courses Summary:"
  working_courses.each do |course|
    puts "Course #{course[:course_id]}: #{course[:enrolled_users]} users, #{course[:assignments]} assignments, #{course[:assignment_activities]} assignment activities"
  end

  working_courses
end

# Get assignments only from courses that work
def get_safe_assignments_from_activities(course_id, max_users: nil)
  puts "📋 Safely getting assignments from activities for course #{course_id}..."

  # First test if the course works with admin user
  begin
    test_activities = get_all_course_activities(course_id, 2)
    puts "✅ Course #{course_id} is accessible, found #{test_activities.size} activities"
  rescue => e
    puts "❌ Course #{course_id} not accessible: #{e.message}"
    return []
  end

  # Get enrolled users
  enrolled_users = get_enrolled_users(course_id)
  return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

  # Filter out problematic users, but don't limit unless specified
  sample_users = enrolled_users.reject { |u| u['fullname'].include?('Guest') }

  # Only limit if max_users is specified
  sample_users = sample_users.first(max_users) if max_users

  puts "Processing #{sample_users.size} users (out of #{enrolled_users.size} total enrolled users)"

  all_results = []

  sample_users.each do |user|
    user_id = user['id']
    user_name = user['fullname']
    user_email = user['email']

    puts "  Processing user: #{user_name} (ID: #{user_id})"

    begin
      # Use your working custom API
      activities = get_all_course_activities(course_id, user_id)

      # Filter for assignment-like activities with proper nil handling
      assignments = activities.select do |activity|
        activity[:submission_date].present? ||
        activity[:evaluation_date].present? ||
        activity[:name].downcase.include?('assignment') ||
        activity[:name].downcase.include?('essay') ||
        activity[:name].downcase.include?('project') ||
        activity[:name].downcase.include?('mock') ||
        (activity[:grade]&.to_f || 0) > 0 ||  # Safe nil handling
        (activity[:number_attempts]&.to_i || 0) > 0  # Safe nil handling
      end

      assignments.each do |assignment|
        all_results << {
          assignment_name: assignment[:name],
          learner_name: user_name,
          learner_email: user_email,
          submission_date: assignment[:submission_date].present? ? assignment[:submission_date] : 'No submission',
          feedback_date: assignment[:evaluation_date].present? ? assignment[:evaluation_date] : 'No feedback',
          grade: assignment[:grade]&.to_f || 0,  # Safe nil handling
          attempts: assignment[:number_attempts]&.to_i || 0,  # Safe nil handling
          section_name: assignment[:section_name],
          ect: assignment[:ect]&.to_f || 0,  # Safe nil handling
          completion_status: assignment[:completiondata] == 1 ? "Completed" : "Not Completed"
        }
      end

    rescue => e
      puts "    ❌ Failed for user #{user_name}: #{e.message}"
      next
    end
  end

  puts "Found #{all_results.size} assignment records"
  all_results
end

# Add a batch processing method for large courses
def get_all_assignments_from_activities_batched(course_id, batch_size: 100)
  puts "📋 Getting ALL assignments from activities for course #{course_id} in batches..."

  enrolled_users = get_enrolled_users(course_id)
  return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

  # Filter out problematic users
  valid_users = enrolled_users.reject { |u| u['fullname'].include?('Guest') }

  all_results = []

  # Process in batches
  valid_users.each_slice(batch_size) do |batch_users|
    puts "Processing batch of #{batch_users.size} users..."

    batch_users.each do |user|
      user_id = user['id']
      user_name = user['fullname']
      user_email = user['email']

      begin
        activities = get_all_course_activities(course_id, user_id)

        # Filter for assignment-like activities
        assignments = activities.select do |activity|
          activity[:submission_date].present? ||
          activity[:evaluation_date].present? ||
          activity[:name].downcase.include?('assignment') ||
          activity[:name].downcase.include?('essay') ||
          activity[:name].downcase.include?('project') ||
          activity[:name].downcase.include?('mock') ||
          (activity[:grade]&.to_f || 0) > 0 ||
          (activity[:number_attempts]&.to_i || 0) > 0
        end

        assignments.each do |assignment|
          all_results << {
            assignment_name: assignment[:name],
            learner_name: user_name,
            learner_email: user_email,
            submission_date: assignment[:submission_date].present? ? assignment[:submission_date] : 'No submission',
            feedback_date: assignment[:evaluation_date].present? ? assignment[:evaluation_date] : 'No feedback',
            grade: assignment[:grade]&.to_f || 0,
            attempts: assignment[:number_attempts]&.to_i || 0,
            section_name: assignment[:section_name],
            ect: assignment[:ect]&.to_f || 0,
            completion_status: assignment[:completiondata] == 1 ? "Completed" : "Not Completed"
          }
        end

      rescue => e
        puts "    ❌ Failed for user #{user_name}: #{e.message}"
        next
      end
    end
  end

  puts "Found #{all_results.size} assignment records from #{valid_users.size} users"
  all_results
end

# Get learners enrolled in a course (for dropdown)
def get_course_learners(course_id)
  puts "👥 Getting learners for course #{course_id}..."

  enrolled_users = get_enrolled_users(course_id)
  return [] unless enrolled_users.is_a?(Array) && enrolled_users.any?

  # Filter out system users and format for dropdown
  learners = enrolled_users.reject { |u| u['fullname'].include?('Guest') || u['fullname'].include?('Admin') }
                          .map do |user|
    {
      moodle_id: user['id'],
      name: user['fullname'],
      email: user['email']
    }
  end.sort_by { |learner| learner[:name].downcase }  # Case-insensitive alphabetical sort

  puts "Found #{learners.size} learners"
  learners
end

# Get assignment summary for subject (fast version)
def get_assignment_summary_for_subject(course_id, max_sample: 100)
  puts "📊 Getting assignment summary for course #{course_id}..."

  # Get a sample of assignment data (much faster)
  sample_data = get_safe_assignments_from_activities(course_id, max_users: max_sample)
  return {} if sample_data.empty?

  # Group by assignment and calculate statistics
  grouped = sample_data.group_by { |data| data[:assignment_name] }

  summary = {}
  grouped.each do |assignment_name, submissions|
    total_participants = submissions.size
    submitted_count = submissions.count { |s| s[:submission_date] != 'No submission' }
    graded_count = submissions.count { |s| s[:grade] > 0 }
    completed_count = submissions.count { |s| s[:completion_status] == 'Completed' }

    grades = submissions.map { |s| s[:grade] }.select { |g| g > 0 }
    average_grade = grades.any? ? (grades.sum / grades.size.to_f).round(2) : 0

    summary[assignment_name] = {
      total_participants: total_participants,
      submitted_count: submitted_count,
      graded_count: graded_count,
      completed_count: completed_count,
      average_grade: average_grade,
      submissions: submissions,
      section_name: submissions.first[:section_name]
    }
  end

  summary
end

# Get specific learner's assignment data (only assignments with feedback)
def get_learner_assignment_data(course_id, learner_moodle_id)
  puts "👤 Getting assignment data for learner #{learner_moodle_id} in course #{course_id}..."

  # Get activities for this specific learner
  activities = get_all_course_activities(course_id, learner_moodle_id)

  # Filter for assignment-like activities
  assignments = activities.select do |activity|
    activity[:submission_date].present? ||
    activity[:evaluation_date].present? ||
    activity[:name].downcase.include?('assignment') ||
    activity[:name].downcase.include?('essay') ||
    activity[:name].downcase.include?('project') ||
    activity[:name].downcase.include?('mock') ||
    (activity[:grade]&.to_f || 0) > 0 ||
    (activity[:number_attempts]&.to_i || 0) > 0
  end

  # Convert to hash indexed by assignment name
  learner_data = {}
  assignments.each do |assignment|
    feedback_date = assignment[:evaluation_date].present? ? assignment[:evaluation_date] : 'No feedback'

    # Only include assignments that have feedback dates
    if feedback_date != 'No feedback'
      learner_data[assignment[:name]] = {
        submission_date: assignment[:submission_date].present? ? assignment[:submission_date] : 'No submission',
        feedback_date: feedback_date,
        grade: assignment[:grade]&.to_f || 0,
        attempts: assignment[:number_attempts]&.to_i || 0,
        completion_status: assignment[:completiondata] == 1 ? "Completed" : "Not Completed"
      }
    end
  end

  puts "Found #{learner_data.size} assignments with feedback for learner"
  learner_data
end

  private

  def get_from_cache(key)
    cached_data = @cache[key]
    return nil unless cached_data

    # Check if cache is expired
    if Time.current > cached_data[:expires_at]
      @cache.delete(key)
      return nil
    end

    cached_data[:data]
  end

  def store_in_cache(key, data)
    @cache[key] = {
      data: data,
      expires_at: Time.current + @cache_duration
    }

    # Clean up expired entries occasionally
    cleanup_cache if @cache.size > 100
  end

  def cleanup_cache
    @cache.delete_if { |_, cached_data| Time.current > cached_data[:expires_at] }
  end
end
