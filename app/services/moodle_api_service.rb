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
end

