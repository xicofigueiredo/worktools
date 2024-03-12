class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def dashboard_lc
    @users = current_user.hubs.first.users_hub.map(&:user).reject { |user| user.role == "lc" }
    @total_balance = {}

    @users.each do |user|
      total_balance_for_user = 0
      user.timelines.each do |timeline|
        total_balance_for_user += timeline.balance
      end
      user.topics_balance = total_balance_for_user
      user.save

    end

    @users.sort_by! { |user| user.topics_balance }
  end

  def profile
    @hub = current_user.hubs.first
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
