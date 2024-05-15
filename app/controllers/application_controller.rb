class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone, if: :user_signed_in?
  before_action :recalculate_timelines_on_first_login

    def set_time_zone
      # Time.zone = current_user.time_zone
    end

  protected

  def recalculate_timelines_on_first_login
    if user_signed_in? && (current_user.last_login_at.nil? || current_user.last_login_at.to_date < Date.today)
      current_user.timelines.find_each do |timeline|
        RecalculateTimelineJob.perform_later(timeline.id)
      end
      current_user.update(last_login_at: Time.current)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :role, { hub_ids: [] }])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
