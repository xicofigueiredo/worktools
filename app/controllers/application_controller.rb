class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone, if: :user_signed_in?
  before_action :check_browser
  before_action :set_notification_count

  def set_time_zone
    # Time.zone = current_user.time_zone
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :role, { hub_ids: [] }])
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def check_browser
    return unless user_signed_in? # Ensure the user is logged in
    return if browser.device.mobile?
    return unless current_user.role.in?(%w[lc learner cm]) # Only for learners or LCs
    return if request.path == unsupported_browser_path # Skip the unsupported browser page
    browser = Browser.new(request.user_agent)

    if !browser.chrome? && !browser.edge?
      render "static/unsupported_browser", layout: "application"
    end
  end

  def set_notification_count
    @notification_count = current_user.notifications.unread.count if user_signed_in?
    if user_signed_in?
      @unread_notifications = current_user.notifications.where(read: false).order(created_at: :desc)
    else
      @unread_notifications = []
    end
  end
end
