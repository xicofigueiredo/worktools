class MoodleApiController < ApplicationController
  before_action :authenticate_user!

  def update_course_topics
    # Find the timeline from parameters (ensure your row provides this ID)
    timeline = Timeline.find(params[:timeline_id])

    # Call the service method.
    MoodleApiService.new.update_moodle_topic_for_course(timeline, current_user.id)
    render json: { success: true }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Timeline not found" }, status: :not_found
  end
end
