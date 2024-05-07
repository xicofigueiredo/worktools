class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_admin_role, only: [:dashboard_admin]
  before_action :check_lc_role, only: [:dashboard_lc, :learner_profile, :attendance, :attendances, :learner_attendances, :update_attendance, :update_absence_attendance, :update_start_time_attendance, :update_end_time_attendance, :update_comments_attendance]

  def dashboard_admin
    if current_user.role == "admin"
      @users = User.all.order(:full_name)
      @hubs = Hub.all.order(:name)
    end
  end

  def dashboard_lc
    @users = current_user.hubs.first.users_hub.map(&:user).reject { |user| user.role == "lc" }
    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    @total_balance = {}

    @users.each do |user|
      total_balance_for_user = 0
      user.timelines.each do |timeline|
        if timeline.balance != nil
          total_balance_for_user += timeline.balance
        end
      end
      user.topics_balance = total_balance_for_user
      user.save

    end

    @users.sort_by! { |user| user.topics_balance }
    @result = []
  end

  def dashboard_dc
    @hubs = Hub.all.order(:name)
  end

  def profile
    if current_user.role != "lc"
      @learner = current_user
      @learner_flag = @learner.learner_flag
      @timelines = @learner.timelines
      @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
      @current_sprint_weeks = @current_sprint.weeks.order(:start_date)
      @sprint_goals = @learner.sprint_goals.find_by(sprint: @current_sprint)
      @skills = @sprint_goals&.skills
      @communities = @sprint_goals&.communities
      @hub_lcs = @learner.hubs.first.users.where(role: 'lc')

      @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
      @kdas_percentage = @current_sprint.count_kdas_total(@learner)

      @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }

      @current_week = Week.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)

      @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }

      @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

      get_kda_averages(@learner.kdas)
      unless @learner
        redirect_to some_fallback_path, alert: "Learner not found."
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

  def learner_profile
    @learner = User.find_by(id: params[:id])
    @learner_flag = @learner.learner_flag
    @notes = @learner.notes.order(created_at: :asc)
    @timelines = @learner.timelines
    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    @current_sprint_weeks = @current_sprint.weeks.order(:start_date)
    @sprint_goals = @learner.sprint_goals.find_by(sprint: @current_sprint)
    @skills = @sprint_goals&.skills
    @communities = @sprint_goals&.communities
    @hub_lcs = @learner.hubs.first.users.where(role: 'lc')

    @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
    @kdas_percentage = @current_sprint.count_kdas_total(@learner)

    @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }

    @current_week = Week.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)

    @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }

    @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

    get_kda_averages(@learner.kdas)
    unless @learner
      redirect_to some_fallback_path, alert: "Learner not found."
    end
  end

  def not_found
    render 'not_found', status: :not_found
  end


  private

  def user_params
    params.require(:user).permit(:full_name, :hub_id)
  end

  def get_kda_averages(kdas)
    sum_mot = 0
    sum_p2p = 0
    sum_ini = 0
    sum_hubp = 0
    sum_sdl = 0

    kdas.each do |kda|
      sum_mot += kda.mot.rating
      sum_p2p += kda.p2p.rating
      sum_ini += kda.ini.rating
      sum_hubp += kda.hubp.rating
      sum_sdl += kda.sdl.rating
    end

    # Calculate averages
    avg_mot = kdas.count > 0 ? sum_mot.to_f.round / kdas.count : 0
    avg_p2p = kdas.count > 0 ? sum_p2p.to_f.round / kdas.count : 0
    avg_ini = kdas.count > 0 ? sum_ini.to_f.round / kdas.count : 0
    avg_hubp = kdas.count > 0 ? sum_hubp.to_f.round / kdas.count : 0
    avg_sdl = kdas.count > 0 ? sum_sdl.to_f.round / kdas.count : 0

    @average_items = [
      { title: 'Self-Directed Learning', average: avg_sdl },
      { title: 'Motivation', average: avg_mot },
      { title: 'Initiative', average: avg_ini },
      { title: 'Hub Participation', average: avg_hubp },
      { title: 'Peer-to-Peer Learning', average: avg_p2p }
    ]

  end

  def check_admin_role
    unless current_user.role == "admin"
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def check_lc_role
    unless current_user.role != "learner"
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def check_sprint_goal(user)
    result = false
    user.sprint_goals.find_by(sprint: Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)).knowledges.each do |knowledge|
      if knowledge.difficulties != nil && knowledge.plan != nil
        result = true
      else
        result = false
      end
    end
    result
  end
end
