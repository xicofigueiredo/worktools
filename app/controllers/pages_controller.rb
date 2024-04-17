class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def dashboard_admin
    if current_user.role == "admin"
      @users = User.all.order(:full_name)
      @hubs = Hub.all.order(:name)
    end
  end

  def dashboard_lc
    get_mocks_dates
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
    @hubs = current_user.hubs
    @timelines = current_user.timelines_sorted_by_balance

    @overall_progress = 0
    @overall_progress_expected = 0
    @timelines.each do |timeline|
      @overall_progress += timeline.progress
      @overall_progress_expected += timeline.expected_progress
    end
    if @timelines.count > 0
      @overall_progress = @overall_progress / @timelines.count
      @overall_progress_expected = @overall_progress_expected / @timelines.count
    else
      @overall_progress = 0
      @overall_progress_expected = 0
    end

    get_mocks_dates

    @activities = []
    current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    current_user.sprint_goals.all.where(sprint: current_sprint).each do |sprint|
      if sprint.skills.count.positive?
        sprint.skills.each do |skill|
          @activities << [skill.extracurricular, skill.smartgoals]
        end
      end
      if sprint.communities.count.positive?
        sprint.communities.each do |community|
          @activities << [community.involved, community.smartgoals]
        end
      end
    end
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

  def get_mocks_dates
    @mock50 = []
    @mock100 = []
    @closest_future_deadline_by_timeline = {}


    current_user.timelines.each do |timeline|
      closest_future_deadline = nil
      timeline.user.user_topics.each do |user_topic|
        @mock50 << user_topic.deadline if user_topic.topic.Mock50
        @mock100 << user_topic.deadline if user_topic.topic.Mock100

        if user_topic.deadline > Date.today
          if closest_future_deadline.nil? || user_topic.deadline < closest_future_deadline
            closest_future_deadline = user_topic.deadline
          end
        end
      end
      @closest_future_deadline_by_timeline[timeline.id] = closest_future_deadline
    end
  end
end
