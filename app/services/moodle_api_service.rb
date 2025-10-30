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
      ano10 = nil
      ano11 = nil
      ano12 = nil

      if category == 4
        as1 = true
        as2 = true
      elsif category == 35
        ano10 = true
        ano11 = true
        ano12 = true
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
        else
          # Check if timeline exists and verify topic count matches activity count
          puts "Timeline #{moodle_timeline.subject.name} already exists, checking topic count..."

          # Get count of activities from Moodle API
          begin
            activities = get_all_course_activities(course_id, moodle_user_id)
            activity_count = activities.is_a?(Array) ? activities.length : 0

            # Get count of existing MoodleTopic records
            existing_topic_count = moodle_timeline.moodle_topics.count

            puts "Activity count: #{activity_count}, Existing topic count: #{existing_topic_count}"

            # If counts don't match, delete existing topics and recreate
            if activity_count != existing_topic_count
              puts "Counts don't match! Deleting existing topics and recreating..."

              # Delete all existing moodle_topics for this timeline
              moodle_timeline.moodle_topics.destroy_all

              # Recreate topics from activities
              activities.each_with_index do |activity, index|
                next if activity[:section_visible] == 0

                MoodleTopic.create!(
                  moodle_timeline_id: moodle_timeline.id,
                  name: activity[:name],
                  unit: activity[:section_name],
                  moodle_id: activity[:id],
                  time: activity[:ect] || 0,
                  order: index + 1,
                  grade: activity[:grade].present? ? activity[:grade].round(2) : nil,
                  done: (activity[:completiondata].to_i == 1 || activity[:completiondata].to_i == 2),
                  completion_date: begin
                    if activity[:evaluation_date].present?
                      DateTime.parse(activity[:evaluation_date])
                    else
                      nil
                    end
                  rescue Date::Error
                    nil
                  end,
                  deadline: moodle_timeline.end_date,
                  percentage: 0.0, # Will be calculated later
                  mock50: activity[:mock50].to_i == 1,
                  mock100: activity[:mock100].to_i == 1,
                  number_attempts: activity[:number_attempts],
                  submission_date: activity[:submission_date].present? ? Time.at(activity[:submission_date].to_i).strftime("%d/%m/%Y %H:%M") : nil,
                  evaluation_date: activity[:evaluation_date].present? ? Time.at(activity[:evaluation_date].to_i).strftime("%d/%m/%Y %H:%M") : nil
                )
              end

              puts "Recreated #{moodle_timeline.moodle_topics.count} topics for timeline"
            else
              puts "Topic count matches activity count, no action needed"
            end
          rescue => e
            puts "Error checking topic count for timeline: #{e.message}"
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













  def check_courses_without_assignments
    subjects = Subject.where.not(moodle_id: nil)
    result = []
    subjects.each do |subject|
      course_id = subject.moodle_id
      assignments = fetch_course_assignments(course_id)
      if assignments.empty?
        result << "Course #{course_id} - #{subject.name} has no assignments"
      end
    end
    result
  end




  # Get assignments for a course using the standard Moodle API
  def fetch_course_assignments(course_id)
    puts "📋 Fetching assignments for course #{course_id} using standard API..."

    params = { 'courseids[0]' => course_id }
    data = call('mod_assign_get_assignments', params)

    courses = data.fetch('courses', [])
    assignments = courses.first ? (courses.first['assignments'] || []) : []

    puts "Found #{assignments.size} assignments"

    detailed_assignments = assignments.map do |a|
      puts "  📝 Processing assignment: #{a['name']}"
      {
        id: a['id'],
        cmid: a['cmid'],
        course_id: a['course'], # <-- correct field
        name: a['name']
      }
    end

    detailed_assignments
  end

  def create_course_assignments(assignments, subject)
    assignments.each do |a|
      assignment_record = MoodleAssignment.find_or_initialize_by(moodle_id: a[:id])
      assignment_record.subject_id = subject.id
      assignment_record.moodle_course_id = a[:course_id]
      assignment_record.cmid = a[:cmid]
      assignment_record.name = a[:name]
      assignment_record.save!
    end
  end

  def create_course_assignments_for_all_subjects
    subjects = Subject.where.not(moodle_id: nil)
    subjects.find_each do |subject|
      course_id   = subject.moodle_id
      assignments = fetch_course_assignments(course_id)
      create_course_assignments(assignments, subject)            # <-- pass subject
    end
  end

































  # Helper method to inspect submission fields
  def inspect_submission_fields(assignments)
    puts "🔍 Inspecting submission fields..."

    sample_submissions = get_assignments_submissions(assignments.is_a?(Array) ? [assignments.first] : [assignments])
    return puts "No submissions found" if sample_submissions.empty?

    sample = sample_submissions.first[:submissions].first
    return puts "No sample submission found" unless sample

    puts "\nAvailable fields in submission object:"
    puts "=" * 60
    sample.keys.sort.each do |key|
      value = sample[key]
      display_value = value.is_a?(Integer) && value > 1000000000 ? Time.at(value).to_s : value.inspect
      puts "  #{key}: #{display_value}"
    end
    puts "=" * 60

    sample
  end

  # Get submissions for assignments
  # Accepts: array of assignment hashes (with :id) or array of assignment IDs
  def get_assignments_submissions(assignments)
    puts "📋 Getting submissions for #{assignments.size} assignments..."

    # Extract assignment IDs if hashes are passed
    assignment_ids = assignments.map { |a| a.is_a?(Hash) ? a[:id] || a['id'] : a }

    organized_submissions = []

    # Try batch call first with array format
    submissions_result = call('mod_assign_get_submissions', { assignmentids: assignment_ids })

    # If batch call fails, fall back to individual calls
    if submissions_result['exception']
      puts "⚠️  Batch call failed, trying individual calls..."

      assignments.each do |assignment|
        assignment_id = assignment.is_a?(Hash) ? (assignment[:id] || assignment['id']) : assignment
        assignment_name = assignment.is_a?(Hash) ? (assignment[:name] || assignment['name']) : nil

        result = call('mod_assign_get_submissions', { assignmentids: [assignment_id] })

        if result['assignments']&.any?
          assignment_data = result['assignments'].first
          submissions = assignment_data['submissions'] || []

          organized_submissions << {
            assignment_id: assignment_id,
            assignment_name: assignment_name,
            submissions: submissions,
            submission_count: submissions.size
          }

          puts "  📝 Assignment ID #{assignment_id}#{assignment_name ? " (#{assignment_name})" : ''}: #{submissions.size} submissions"
        end
      end
    else
      # Batch call succeeded, process results
      if submissions_result['assignments']
        submissions_result['assignments'].each do |assignment_data|
          assignment_id = assignment_data['assignmentid']
          submissions = assignment_data['submissions'] || []

          # Find the assignment name if we have it
          assignment_info = assignments.find { |a| (a.is_a?(Hash) ? (a[:id] || a['id']) : a) == assignment_id }
          assignment_name = assignment_info.is_a?(Hash) ? (assignment_info[:name] || assignment_info['name']) : nil

          organized_submissions << {
            assignment_id: assignment_id,
            assignment_name: assignment_name,
            submissions: submissions,
            submission_count: submissions.size
          }

          puts "  📝 Assignment ID #{assignment_id}#{assignment_name ? " (#{assignment_name})" : ''}: #{submissions.size} submissions"
        end
      end
    end

    organized_submissions
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

    # Get submission status for a specific assignment and user
    def fetch_submission_status(assignment_id, user_id)
      params = { 'assignid' => assignment_id, 'userid' => user_id }
      call('mod_assign_get_submission_status', params)
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

  # Get learners enrolled in a course
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


end
