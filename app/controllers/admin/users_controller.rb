class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    userss = User.all.order(:full_name)
    @users = userss.includes(:hubs, :main_hub)
  end

  def edit
    @user = User.find(params[:id])
    @is_cm = @user.role == 'cm'
    @is_admin = @user.role == 'admin'
    @is_lc = @user.role == 'lc'
    @is_learner = @user.role == 'learner'
    @is_guardian = @user.role == 'guardian'
    @subjects = Subject.where.not(id: 666).order(:name)
    @learners = User.where(role: 'learner', deactivate: false).order(:full_name)
    @hubs = Hub.all
    @user_hubs = @user.users_hubs.map { |uh| uh.hub }
    render partial: 'form', locals: { user: @user }
  end


  def update
    @user = User.find(params[:id])

    # Extract hub_ids and main_hub_id from the parameters and remove them so they’re not mass-assigned.
    hub_ids = (params[:user].delete(:hub_ids) || []).reject(&:blank?)
    main_hub_id = params[:user].delete(:main_hub_id)

    if @user.update(user_params)
      # Wrap the association update in a transaction.
      ActiveRecord::Base.transaction do
        # Destroy all existing hub associations.
        @user.users_hubs.destroy_all

        # For each hub_id submitted, create a new join record with the main flag set correctly.
        hub_ids.each do |hub_id|
          # Convert both IDs to strings for reliable comparison.
          is_main = (hub_id.to_s == main_hub_id.to_s)
          @user.users_hubs.create!(hub_id: hub_id, main: is_main)
        end
      end
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
      :deactivate, :moodle_id, :changed_password, kids: [], subjects: []
    )
  end
end
