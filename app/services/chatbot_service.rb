class ChatbotService
  include ActionView::Helpers::TextHelper

  def initialize(chat)
    @chat = chat

    # Fix API key detection - check for blank/empty strings properly
    @api_key = ENV['OPENAI_API_KEY'].presence ||
               ENV['OPENAI_ACCESS_TOKEN'].presence ||
               Rails.application.credentials.openai_api_key.presence

    if @api_key.present?
      @openai_client = OpenAI::Client.new(api_key: @api_key)
    else
      Rails.logger.warn "ChatbotService: No OpenAI API key configured"
    end
  end

  def generate_response(user_message)
    # Add user message to chat history
    @chat.add_message('user', user_message)

    # Check if API key is configured
    unless @api_key.present?
      assistant_message = "I apologize, but the AI tutoring service is not configured. Please contact your administrator to set up the OpenAI API key."
      @chat.add_message('assistant', assistant_message)
      return assistant_message
    end

    # Prepare messages for OpenAI API
    messages = prepare_messages

    begin
      # Use the older OpenAI gem syntax - try gpt-4o-mini first
      response = @openai_client.completions(
        engine: "gpt-4o-mini",
        prompt: build_prompt_from_messages(messages),
        max_tokens: 500,
        temperature: 0.7
      )

      assistant_message = response.dig("choices", 0, "text")&.strip

      if assistant_message.present?
        # Add assistant response to chat history
        @chat.add_message('assistant', assistant_message)
        assistant_message
      else
        fallback_response
      end
    rescue => e
      Rails.logger.error "ChatbotService error: #{e.message}"

      # If gpt-4o-mini fails, try fallback to gpt-3.5-turbo-instruct
      if e.message.include?("model") || e.message.include?("engine")
        Rails.logger.info "Falling back to gpt-3.5-turbo-instruct"
        begin
          response = @openai_client.completions(
            engine: "gpt-3.5-turbo-instruct",
            prompt: build_prompt_from_messages(messages),
            max_tokens: 500,
            temperature: 0.7
          )
          assistant_message = response.dig("choices", 0, "text")&.strip
          @chat.add_message('assistant', assistant_message) if assistant_message.present?
          return assistant_message || fallback_response
        rescue => fallback_error
          Rails.logger.error "Fallback model also failed: #{fallback_error.message}"
        end
      end

      # Handle quota exceeded specifically
      if e.message.include?("quota") || e.message.include?("billing")
        assistant_message = "I apologize, but the AI service has reached its usage limit. Please contact your administrator about the OpenAI billing plan."
      else
        assistant_message = fallback_response
      end

      @chat.add_message('assistant', assistant_message)
      assistant_message
    end
  end

  private

  def prepare_messages
    messages = []

    # Add system prompt
    messages << {
      role: "system",
      content: @chat.system_prompt
    }

    # Add conversation history (last 10 messages to stay within token limits)
    recent_messages = @chat.chat_messages.in_order.last(10)

    recent_messages.each do |message|
      messages << {
        role: message.role,
        content: truncate(message.content, length: 1000)
      }
    end

    messages
  end

  def build_prompt_from_messages(messages)
    # Convert chat messages to a single prompt for the older completions API
    prompt_parts = []

    messages.each do |message|
      case message[:role]
      when "system"
        prompt_parts << "System: #{message[:content]}"
      when "user"
        prompt_parts << "User: #{message[:content]}"
      when "assistant"
        prompt_parts << "Assistant: #{message[:content]}"
      end
    end

    prompt_parts << "Assistant:"
    prompt_parts.join("\n\n")
  end

  def fallback_response
    "I apologize, but I'm having trouble processing your request right now. Please try again in a moment, or contact your learning coach for assistance."
  end
end
