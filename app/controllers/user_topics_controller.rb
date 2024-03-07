class UserTopicsController < ApplicationController
  before_action :set_user_topic, only: [:toggle_done]

  def toggle_done
    if @user_topic.update(done: params[:user_topic][:done])
      render json: { status: "success" }, status: :ok
    else
      render json: { status: "error", message: @user_topic.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def set_user_topic
    @user_topic = current_user.user_topics.find(params[:id])
  end

  # If you're sending more parameters, ensure you have a strong parameters method
  def user_topic_params
    params.require(:user_topic).permit(:done)
  end
end
