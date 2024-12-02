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

    # def edit
    #   super
    # end

    def update
      super do |resource|
        if resource.errors.empty?
          # Ensure that `changed_password` is set to true after a successful password reset
          resource.update(changed_password: true)
        end
      end
    end
  end
end
