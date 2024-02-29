class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def dashboard_lc
    @users = current_user.hub.users_hub.map(&:user)
    @total_balance = 0
    @users.each do |user|
        user.timelines.each do |timeline|
          @total_balance += timeline.balance
        end
    end
  end

  def profile
    @hub = current_user.users_hub.hub
    if current_user.timelines.count.positive?
      @subject = current_user.timelines.first.subject
      Subject.where(category: :tbe).destroy_all
    else
      @fake_subject = Subject.create(name: "No Subject", category: :tbe)
      @subject = @fake_subject
    end
    @timelines = current_user.timelines
  end

  def edit_profile
    @hub = current_user.users_hub.hub
    @subject = current_user.timelines.first.subject
    @timelines = current_user.timelines
  end

  def update_profile
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit_profile
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :hub_id)
  end
end
