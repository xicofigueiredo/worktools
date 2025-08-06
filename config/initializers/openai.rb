# OpenAI Configuration
# The openai gem doesn't use a configure block in recent versions
# Configuration is handled through environment variables or client initialization

# Set OpenAI API key as environment variable if not already set
unless ENV['OPENAI_API_KEY']
  if Rails.application.credentials.openai_api_key
    ENV['OPENAI_API_KEY'] = Rails.application.credentials.openai_api_key
  end
end

# Set organization ID if available
unless ENV['OPENAI_ORGANIZATION_ID']
  if Rails.application.credentials.openai_organization_id
    ENV['OPENAI_ORGANIZATION_ID'] = Rails.application.credentials.openai_organization_id
  end
end
