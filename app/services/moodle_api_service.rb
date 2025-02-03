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
    user = User.find_by(moodle_id: moodle_id)
    return puts "User not found!" if user.nil?

    courses = get_user_courses(email) # Get enrolled courses
    return puts "No courses found!" if courses.empty?

    created_timelines = []

    courses.each do |course|
      subject = Subject.find_by(moodle_id: course.split(":").first.to_i) # Extract Moodle ID and find the subject

      if subject
        timeline = Timeline.find_or_create_by!(
          user_id: user.id,
          subject_id: subject.id,
          start_date: Date.today,
          end_date: Date.today + 1.year,
          balance: 0,
          expected_progress: 0,
          progress: 0,
          total_time: 0,
          difference: 0
        )
        created_timelines << timeline
        puts "Created #{timeline.subject.name} Timeline for #{course.split(':').last.strip}"
      end
    end

    user.user_topics.each do |topic|
      topic.deadline = Date.today
      topic.save!
    end

    puts "✅ Created #{created_timelines.size} timelines for #{email}"
  end




  # 6) Create user topics based on enrolled courses
  def create_user_topics(email)
    user_id = get_user_id(email)
    return puts "User not found!" unless user_id

    courses = get_user_courses(email)
    return puts "No courses found!" if courses.empty?

    courses.each do |course|
      subject = Subject.find_or_create_by(moodle_id: course['shortname'])
      subject.update(moodle_id: course['id'])

      UserTopic.create!(
        user_id: user_id,
        subject_id: subject.id,
        moodle_course_id: course['id'],
        status: 'active'
      )
      puts "Created topic for #{course['shortname']} (#{course['id']})"
    end
  end

  # service = MoodleApiService.new
  # courses = service.get_all_courses
  # francisco@bravegenerationacademy.com
  #lidia@bravegenerationacademy.com
  #I need to create user topics


end
