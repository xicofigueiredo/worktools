class ChatbotService
  include ActionView::Helpers::TextHelper

  def initialize(chat)
    @chat = chat
    @openai_client = OpenAI::Client.new(
      access_token: Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY'] || ENV['OPENAI_ACCESS_TOKEN'],
      organization_id: Rails.application.credentials.openai_organization_id || ENV['OPENAI_ORGANIZATION_ID']
    )
  end

  def generate_response(user_message)
    # Add user message to chat history
    @chat.add_message('user', user_message)

    # Prepare messages for OpenAI API
    messages = prepare_messages

    begin
      response = @openai_client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: messages,
          max_tokens: 500,
          temperature: 0.7
        }
      )

      assistant_message = response.dig("choices", 0, "message", "content")

      if assistant_message.present?
        # Add assistant response to chat history
        @chat.add_message('assistant', assistant_message)
        assistant_message
      else
        fallback_response
      end
    rescue => e
      Rails.logger.error "ChatbotService error: #{e.message}"
      fallback_response
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

  def fallback_response
    "I apologize, but I'm having trouble processing your request right now. Please try again in a moment, or contact your learning coach for assistance."
  end
end
