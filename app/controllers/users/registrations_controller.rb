module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |user|
        if user.persisted?
          if user.role == 'parent'
            # Prompt parents to update their password
            user.update(changed_password: false)
          elsif user.role == 'learner'
            # Learners do not need to update their password
            user.update(changed_password: true)
          end

          if params[:user][:hub_ids].present?
            hub_ids = Array(params[:user][:hub_ids])
            hub_ids.each do |hub_id|
              UsersHub.create(user:, hub_id:) unless hub_id.blank?
            end
            LearnerFlag.create(user: user) if user.learner?
          end
        end
      end
    end

    def update
      super do |resource|
        if resource.errors.empty? && resource.saved_change_to_encrypted_password?
          # Only update `changed_password` for parents
          if resource.role == 'parent'
            resource.update(changed_password: true)
          end
        end
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :role, hub_ids: [])
    end
  end
end
