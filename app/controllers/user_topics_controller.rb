class UserTopicsController < ApplicationController
  include ProgressCalculations

  before_action :set_user_topic, only: [:toggle_done]

  def toggle_done
    current_date = if Date.today.sunday?
                     Date.today - 2
                   elsif Date.today.saturday?
                     Date.today - 1
                   else
                     Date.today
                   end
    current_week = Week.find_by('start_date <= ? AND end_date >= ?', current_date, current_date)
    current_timeline = Timeline.find_by(id: params[:timeline_id])
    if @user_topic.update(done: params[:user_topic][:done])
      calculate_progress_and_balance([current_timeline])
      current_timeline.update_weekly_progress(current_week)
      render json: { status: "success", timeline_id: params[:timeline_id].to_s }, status: :ok
    else
      render json: { status: "error", message: @user_topic.errors.full_messages.to_sentence },
             status: :unprocessable_entity
    end
  end

  private

  def set_user_topic
    @user_topic = current_user.user_topics.find(params[:id])
  end

  # If you're sending more parameters, ensure you have a strong parameters method
  def user_topic_params
    params.require(:user_topic).permit(:done, :timeline_id)
  end
end
