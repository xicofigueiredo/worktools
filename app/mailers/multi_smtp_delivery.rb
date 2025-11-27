# Custom delivery method that automatically selects the correct SMTP account
# based on the 'from' address in the email
require 'net/smtp'

class MultiSmtpDelivery
  def initialize(settings = {})
    @default_settings = settings
  end

  def deliver!(mail)
    # Determine which SMTP account to use based on the 'from' address
    from_address = extract_from_address(mail)
    smtp_settings = smtp_settings_for(from_address)

    # Create SMTP connection with selected credentials
    smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
    smtp.enable_starttls if smtp_settings[:enable_starttls_auto]
    smtp.open_timeout = smtp_settings[:open_timeout] || 30
    smtp.read_timeout = smtp_settings[:read_timeout] || 300

    begin
      # Extract domain from username for SMTP start
      domain = smtp_settings[:user_name].split('@').last rescue 'smtp.office365.com'

      smtp.start(domain, smtp_settings[:user_name], smtp_settings[:password], smtp_settings[:authentication]) do |smtp_client|
        # Get all recipients (to, cc, bcc)
        destinations = [mail.to, mail.cc, mail.bcc].flatten.compact.uniq
        smtp_client.send_message(mail.encoded, mail.from.first, destinations)
      end
    ensure
      smtp.finish if smtp.started?
    end
  end

  private

  def extract_from_address(mail)
    from = mail.from
    return nil if from.blank?
    address = from.is_a?(Array) ? from.first : from
    address.to_s.downcase.strip
  end

  def smtp_settings_for(from_address)
    # Select SMTP credentials based on 'from' address
    if from_address&.include?('contact@bravegenerationacademy.com')
      contact_smtp_settings
    elsif from_address&.include?('humanresources@bravegenerationacademy.com')
      humanresources_smtp_settings
    else
      # Default to worktools account
      worktools_smtp_settings
    end
  end

  def worktools_smtp_settings
    {
      address: 'smtp.office365.com',
      port: 587,
      authentication: 'login',
      user_name: ENV['OUTLOOK_USERNAME'],
      password: ENV['OUTLOOK_PASSWORD'],
      enable_starttls_auto: true,
      open_timeout: 30,
      read_timeout: 300
    }
  end

  def contact_smtp_settings
    {
      address: 'smtp.office365.com',
      port: 587,
      authentication: 'login',
      user_name: ENV['OUTLOOK_CONTACT_USERNAME'],
      password: ENV['OUTLOOK_CONTACT_PASSWORD'],
      enable_starttls_auto: true,
      open_timeout: 30,
      read_timeout: 300
    }
  end

  def humanresources_smtp_settings
    {
      address: 'smtp.office365.com',
      port: 587,
      authentication: 'login',
      user_name: ENV['OUTLOOK_HUMANRESOURCES_USERNAME'],
      password: ENV['OUTLOOK_HUMANRESOURCES_PASSWORD'],
      enable_starttls_auto: true,
      open_timeout: 30,
      read_timeout: 300
    }
  end
end
