class MicrosoftGraphService
  include HTTParty

  AUTH_URL  = "https://login.microsoftonline.com"
  GRAPH_URL = "https://graph.microsoft.com/v1.0"

  def initialize
    @tenant_id     = ENV['MS_TENANT_ID']
    @client_id     = ENV['MS_CLIENT_ID']
    @client_secret = ENV['MS_CLIENT_SECRET']
  end

  def create_event(visit)
    token = fetch_access_token
    return nil unless token

    tz = visit.hub_timezone

    event_body_content = build_event_body_content(visit)

    # Map the visit details to Microsoft's Event structure
    body = {
      subject: "#{visit.visit_type.titleize} - #{visit.hub.name} Hub - Parent: #{visit.first_name}, Learner: #{visit.learner_name}",
      body: {
        contentType: "HTML",
        content: event_body_content
      },
      start: {
        dateTime: visit.start_time.in_time_zone(tz).iso8601,
        timeZone: tz
      },
      end: {
        dateTime: visit.end_time.in_time_zone(tz).iso8601,
        timeZone: tz
      },
      location: { displayName: visit.hub.name }
    }

    target_emails = [visit.hub.hub_email, 'contact@bravegenerationacademy.com']
    hub_response_object = nil

    target_emails.each do |email|
      response = self.class.post(
        "#{GRAPH_URL}/users/#{email}/calendar/events",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Content-Type'  => 'application/json'
        },
        body: body.to_json
      )
      if email == visit.hub.hub_email
        hub_response_object = response
      end

      unless response.success?
        Rails.logger.error("MS Graph Error for #{email}: #{response.code} - #{response.body}")
      end
    end

    if hub_response_object && hub_response_object.success?
      hub_response_object.parsed_response
    else
      Rails.logger.error("Failed to create primary Outlook event for Hub: #{visit.hub.name}")
      nil
    end
  end

  private

  def fetch_access_token
    # Requesting a 'client_credentials' token for application-level access
    response = self.class.post(
      "#{AUTH_URL}/#{@tenant_id}/oauth2/v2.0/token",
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: {
        client_id:     @client_id,
        scope:         'https://graph.microsoft.com/.default',
        client_secret: @client_secret,
        grant_type:    'client_credentials'
      }
    )

    response.success? ? response.parsed_response['access_token'] : nil
  end

  def build_event_body_content(visit)
    # Define internal notes text (Constant text from your request)
    internal_notes = <<~NOTES
      Test user UK Curriculum platform: URL: https://learn.bravegenerationacademy.com/login/ (11) LWS 7: guest.year7 Password: Guest@y7 (12 - 13) LWS 8: guest.year8 Password: Guest@y8 (13 - 14) LWS 9: guest.year9 Password: Guest@y9 (14 -16) IGCSE: guest.igcse Password: Guest@igcse1 (16-18) A-Levels: guest.alevel Password: Guest@alevel1 -- Test user US Curriculum (FIA): URL: https://usuniversitypathways.schoolsplp.com/login Guest access info: https://edubgabravegeneration-my.sharepoint.com/:b:/g/personal/contact_bravegenerationacademy_com/EUICvLjvt8JJpiLOMqUikaQBmHFZDfiniBZ-DyolsdT4UQ?e=4ofZlS -- Test user UP Programme platform: URL: https://learn.genexinstitute.com/login/bga user: demo@bga.com password: password
    NOTES

    # Construct HTML
    <<~HTML
      <h3>Customer Info</h3>
      --------------------<br>
      <strong>Name:</strong> #{visit.full_name}<br>
      <strong>Email:</strong> #{visit.email}<br>
      <strong>Phone Number:</strong> #{visit.phone}<br>
      <strong>Time Zone:</strong> #{visit.hub_timezone}<br>
      <strong>Notes:</strong> #{visit.special_requests.presence || 'N/A'}<br>
      <br>

      <h3>Booking Info</h3>
      --------------------<br>
      <strong>Service name:</strong> #{visit.visit_type.titleize}<br>
      <strong>Location:</strong> #{visit.hub.address} (#{visit.hub.google_map_link})<br>
      <br>

      <h3>Custom Fields</h3>
      --------------------<br>
      <strong>Question - What is(are) the Learner(s)'s name(s)?</strong><br>
      Answer - #{visit.learner_name}<br>
      <br>
      <strong>Question - What is(are) the Learner(s)'s age(s)?</strong><br>
      Answer - #{visit.learner_age}<br>
      <br>
      <strong>Question - Select the Learner(s)'s academic level</strong><br>
      Answer - #{visit.learner_academic_level}<br>
      <br>

      <h3>Internal Notes</h3>
      --------------------<br>
      #{internal_notes}
    HTML
  end
end
