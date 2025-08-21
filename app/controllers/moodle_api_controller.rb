class MoodleApiController < ApplicationController
  before_action :authenticate_user!

  def update_course_topics
    # Find the timeline from parameters (ensure your row provides this ID)
    timeline = Timeline.find(params[:timeline_id])

    # Call the service method.
    result = MoodleApiService.new.update_course_topics_for_learner(current_user, timeline)
    if result.is_a?(Hash) && result[:error].present?
      render json: { success: false, error: result[:error] }, status: :unprocessable_entity
    else
      render json: { success: true, **(result || {}) }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Timeline not found" }, status: :not_found
  end
end
