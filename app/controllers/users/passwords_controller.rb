module Users
  class PasswordsController < Devise::PasswordsController
    # You can customize any actions here if needed
    # For example, override the new method
    # def new
    #   super
    # end

    # def create
    #   super
    # end

    def edit
      super
      # Store the reset password token in instance variable for the view
      @reset_password_token = params[:reset_password_token]
    end

    def update
      # Preserve the reset password token for re-rendering the form on validation errors
      @reset_password_token = params[:user][:reset_password_token] if params[:user]
      
      super do |resource|
        if resource.errors.empty?
          # Ensure that `changed_password` is set to true after a successful password reset
          resource.update(changed_password: true)
        end
      end
    end
  end
end
