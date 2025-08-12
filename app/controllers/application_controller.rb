class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_browser
  before_action :count_notifications
  before_action :set_current_role

  # Method to switch roles (only for admins)
  def switch_role
    if current_user.role == 'admin' && params[:role].in?(['admin', 'learner', 'lc', 'cm', 'exams', 'parent'])
      session[:viewing_role] = params[:role]
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path, alert: "Unauthorized"
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :hub_ids => []])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :hub_ids => []])
  end

  def count_notifications
    @notification_count = current_user&.notifications&.unread&.count || 0
    @unread_notifications = current_user&.notifications&.where(read: false)&.order(created_at: :desc) || []
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

  def set_current_role
    # Allow admins to switch roles for testing different navbars
    # Admins ALWAYS see the switcher, regardless of current viewing role
    if current_user&.role == 'admin'
      @current_viewing_role = session[:viewing_role] || 'admin'
      @available_roles = ['admin', 'learner', 'lc', 'cm', 'exams', 'parent']
    else
      # Non-admins see their actual role
      @current_viewing_role = determine_user_role(current_user)
      @available_roles = nil
    end
  end

  def determine_user_role(user)
    return nil unless user

    case user.role
    when 'admin'
      'admin'
    when 'guardian'
      'parent'
    when 'lc'
      'lc'
    when 'cm'
      'cm'
    when 'exams'
      'exams'
    else
      'learner'  # Default for regular users/learners
    end
  end
end
