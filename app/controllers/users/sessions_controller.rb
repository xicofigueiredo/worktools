# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    def create
      super do |resource|
        # Check if this is the first login (when last_login_at is nil)
        is_first_login = resource.last_login_at.nil?

        # Always update last_login_at for successful logins
        resource.update_column(:last_login_at, Time.current)

        # Redirect to profile edit on first login
        if is_first_login
          redirect_to edit_user_registration_path and return
        end
      end
    end

    def update
      super do |resource|
        resource.update(changed_password: true) if resource.errors.empty?
      end
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
