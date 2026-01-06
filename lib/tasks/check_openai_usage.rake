namespace :openai do
  desc "Check OpenAI API usage and rate limits"
  task check_usage: :environment do
    api_key = ENV['OPENAI_API_KEY'].presence ||
              ENV['OPENAI_ACCESS_TOKEN'].presence ||
              Rails.application.credentials.openai_api_key.presence

    if api_key.blank?
      puts "❌ No OpenAI API key found in environment or credentials"
      exit 1
    end

    require 'net/http'
    require 'json'

    uri = URI('https://api.openai.com/v1/usage')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{api_key}"

    begin
      response = http.request(request)

      if response.code == '200'
        data = JSON.parse(response.body)
        puts "\n📊 OpenAI API Usage:"
        puts "=" * 50
        puts "Total tokens used: #{data['total_usage'] || 'N/A'}"
        puts "Requests made: #{data['requests'] || 'N/A'}"
        puts "Rate limit status: #{data['rate_limit'] || 'N/A'}"
        puts "=" * 50
      else
        puts "❌ Error checking usage: #{response.code} - #{response.body}"
      end
    rescue => e
      puts "❌ Error: #{e.message}"
      puts "\n💡 Tip: You can also check usage at: https://platform.openai.com/usage"
    end

    puts "\n💡 For detailed usage and billing, visit: https://platform.openai.com/usage"
    puts "💡 For rate limits, visit: https://platform.openai.com/account/rate-limits"
  end
end
