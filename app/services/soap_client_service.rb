class SoapClientService
  def initialize
    @client = Savon.client(
      wsdl: 'http://localhost:3000/',
      ssl_verify_mode: :none,
      log: true,
      pretty_print_xml: true
    )
  end

  def get_user_details(user_id)
    response = @client.call(:get_user_details, message: { user_id: user_id })
    response.body[:get_user_details_response]
  rescue Savon::SOAPFault => e
    Rails.logger.error "SOAP Fault: #{e.message}"
    nil
  rescue Savon::HTTPError => e
    Rails.logger.error "HTTP Error: #{e.message}"
    nil
  end
end
