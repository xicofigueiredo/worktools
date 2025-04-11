class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.includes(users_hubs: :hub).all
  end

  def edit
    @user = User.find(params[:id])
    render partial: 'form', locals: { user: @user }
  end


  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully"
    else
      render :edit
    end
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(
      :email, :full_name, :role, :topics_balance, :level,
      :birthday, :nationality, :native_language, :profile_pic,
      :deactivate, :moodle_id, :kids, :changed_password, :subjects
    )
  end
end
