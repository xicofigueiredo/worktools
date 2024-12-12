# app/services/moodle_api_service.rb
class MoodleApiService
  def initialize
    @base_url = ENV['MOODLE_API_BASE_URL']
    @token = ENV['MOODLE_API_TOKEN']
  end

  def call(function_name, params = {})
    params.merge!({
      wstoken: @token,
      wsfunction: function_name,
      moodlewsrestformat: 'json'
    })

    response = RestClient.get(@base_url, { params: params })
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    { error: e.response }
  end

  def get_courses
    call('gradereport_overview_get_course_grades', {})
  end
end
