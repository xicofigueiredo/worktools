class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone, if: :user_signed_in?

    def set_time_zone
      # Time.zone = current_user.time_zone
    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :role, { hub_ids: [] }])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
