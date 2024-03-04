class UserTopicsController < ApplicationController
  def toggle_done
    user_topic = current_user.user_topics.find_by(topic_id: params[:topic_id])
    if user_topic
      user_topic.update(done: !user_topic.done)
      render json: { done: user_topic.done }
    else
      render json: { error: "User topic not found" }, status: :not_found
    end
  end
end
