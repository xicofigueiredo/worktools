# OpenAI Configuration
Rails.application.config.after_initialize do
  # Set default OpenAI client configuration
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY']
    config.organization_id = Rails.application.credentials.openai_organization_id || ENV['OPENAI_ORGANIZATION_ID'] # Optional
    config.log_errors = Rails.env.development? # Only log errors in development
  end
end
