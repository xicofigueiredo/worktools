class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show, :destroy]
  before_action :set_subjects, only: [:index, :show]

  def index
    @chats = current_user.chats.includes(:subject, :chat_messages).order(updated_at: :desc)
    @current_chat = @chats.first
    @subjects = Subject.all.order(:name)
  end

  def show
    @subjects = Subject.all.order(:name)
    @messages = @chat.chat_messages.in_order.includes(:chat)
  end

  def create
    @subject = Subject.find(params[:subject_id])

    # Always create a new chat session for subject changes
    @chat = Chat.find_or_create_for_user_and_subject(current_user, @subject)

    redirect_to @chat
  end

  def send_message
    @chat = Chat.find(params[:id])
    authorize_chat_access!

    user_message = params[:message]&.strip

    if user_message.blank?
      render json: { error: 'Message cannot be empty' }, status: :unprocessable_entity
      return
    end

    # Generate response using ChatbotService
    chatbot_service = ChatbotService.new(@chat)
    assistant_response = chatbot_service.generate_response(user_message)

    # Update chat timestamp
    @chat.touch

    if request.headers['Accept']&.include?('text/html')
      # Handle regular form submission
      redirect_to @chat, notice: 'Message sent successfully!'
    else
      # Handle AJAX/Turbo request
      render json: {
        success: true,
        user_message: user_message,
        assistant_response: assistant_response,
        timestamp: Time.current.strftime('%H:%M')
      }
    end
  rescue => e
    Rails.logger.error "ChatsController#send_message error: #{e.message}"

    if request.headers['Accept']&.include?('text/html')
      redirect_to @chat, alert: 'Sorry, there was an error processing your message.'
    else
      render json: { error: 'Sorry, there was an error processing your message.' }, status: :internal_server_error
    end
  end

  def destroy
    authorize_chat_access!
    @chat.destroy
    redirect_to chats_path, notice: 'Chat deleted successfully.'
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def set_subjects
    @subjects = Subject.all.order(:name)
  end

  def authorize_chat_access!
    unless @chat.user == current_user || current_user.admin?
      redirect_to chats_path, alert: 'You are not authorized to access this chat.'
    end
  end

  def chat_params
    params.require(:chat).permit(:subject_id)
  end
end
