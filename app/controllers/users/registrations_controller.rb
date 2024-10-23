class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super do |user|
      if user.persisted? && params[:user][:hub_ids].present?
        # Ensure hub_ids is treated as an array
        hub_ids = Array(params[:user][:hub_ids])
        hub_ids.each do |hub_id|
          UsersHub.create(user:, hub_id:) unless hub_id.blank?
        end
      end
    end
  end

  def update
    super do |resource|
      resource.update(changed_password: true) if resource.errors.empty? && resource.saved_change_to_encrypted_password?
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :role, hub_ids: [])
  end
end
