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

    # Ensure your Hub model has an email field for their Outlook account
    hub_email = visit.hub.hub_email
    tz = visit.hub_timezone # From your HubVisit model

    # Map the visit details to Microsoft's Event structure
    body = {
      subject: "#{visit.visit_type.titleize}: #{visit.learner_name}",
      body: {
        contentType: "HTML",
        content: "<strong>Parent:</strong> #{visit.full_name}<br><strong>Notes:</strong> #{visit.special_requests}"
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

    # Use httparty to post the event
    response = self.class.post(
      "#{GRAPH_URL}/users/#{hub_email}/calendar/events",
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type'  => 'application/json'
      },
      body: body.to_json
    )

    response.success? ? response.parsed_response : nil
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
end
