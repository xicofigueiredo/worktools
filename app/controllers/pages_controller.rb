require 'utilities/timeframe'

class PagesController < ApplicationController
  include WorkingDaysAndHolidays

  skip_before_action :authenticate_user!
  before_action :check_admin_role, only: [:dashboard_admin]
  before_action :check_lc_role, only: [:dashboard_lc, :learner_profile, :attendance, :attendances, :learner_attendances, :update_attendance, :update_absence_attendance, :update_start_time_attendance, :update_end_time_attendance, :update_comments_attendance]

  def dashboard_admin
    if current_user.role == "admin"
      @hubs = Hub.all.order(:name)
    end
  end

  def hub_selection
    @hubs = current_user.hubs
  end

  def dashboard_lc
    if current_user.hubs.count > 1 && params[:hub_id].nil?
      redirect_to dashboard_dc_path
    end

    if params[:hub_id].nil?
      @selected_hub = current_user.hubs.first
    else
      @selected_hub = Hub.find_by(id: params[:hub_id])
    end

    @users = @selected_hub.users.where(role: 'learner', deactivate: [false, nil])
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

    @users = @users.order(topics_balance: :asc)

  end

  def dashboard_dc
    @hubs = current_user.hubs
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

      @yearly_presence = calc_yearly_presence(@learner)

      @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
      @kdas_percentage = @current_sprint.count_kdas_total(@learner)

      @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }

      @current_week = Week.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)

      @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }

      @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

      get_kda_averages(@learner.kdas, @current_sprint)
      unless @learner
        redirect_to some_fallback_path, alert: "Learner not found."
      end
    else
      redirect_to dashboard_lc_path
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
    current_date = Date.today

    @learner = User.find_by(id: params[:id])
    @learner_flag = @learner.learner_flag
    @notes = @learner.notes.order(created_at: :desc)
    @timelines = @learner.timelines
    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", current_date, current_date).first
    @current_sprint_weeks = @current_sprint.weeks.order(:start_date)
    @sprint_goals = @learner.sprint_goals.find_by(sprint: @current_sprint)
    @skills = @sprint_goals&.skills
    @communities = @sprint_goals&.communities
    @hub_lcs = @learner.hubs.first.users.where(role: 'lc')
    @holidays = @learner.holidays

    @yearly_presence = calc_yearly_presence(@learner)

    @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
    @kdas_percentage = @current_sprint.count_kdas_total(@learner)

    @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }

    @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }

    @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

    @current_weekly_goal_date = current_date

    if current_date.saturday?
      @current_weekly_goal_date = current_date - 1.day
    elsif current_date.sunday?
      @current_weekly_goal_date = current_date - 2.days
    end

    @current_week = Week.find_by("start_date <= ? AND end_date >= ?", @current_weekly_goal_date, @current_weekly_goal_date)

    @weekly_goal = @learner.weekly_goals.joins(:week).find_by("weeks.start_date <= ? AND weeks.end_date >= ?", @current_weekly_goal_date, @current_weekly_goal_date)


    get_kda_averages(@learner.kdas, @current_sprint)

    unless @learner
      redirect_to some_fallback_path, alert: "Learner not found."
    end
  end

  def change_weekly_goal
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    week = Week.find_by("start_date <= ? AND end_date >= ?", date, date)
    learner = User.find_by(id: params[:learner_id])
    current_date = params[:current_date] ? Date.parse(params[:current_date]) : Date.today
    weekly_goal = learner.weekly_goals.joins(:week).find_by("weeks.start_date <= ? AND weeks.end_date >= ?", date, date)

    update_weekly_goal(weekly_goal, week, learner, date)
  end

  def not_found
    render 'not_found', status: :not_found
  end


  private

  def update_weekly_goal(weekly_goal, week, learner, date)
    render turbo_stream:
      turbo_stream.replace("lp_weekly_goal",
                            partial: "pages/partials/weekly_goals",
                            locals: {weekly_goal: weekly_goal,
                                    current_week: week,
                                    learner: learner,
                                    current_date: date})
  end

  def user_params
    params.require(:user).permit(:full_name, :hub_id)
  end

  def get_kda_averages(kdas, current_sprint)
    sum_mot = 0
    sum_p2p = 0
    sum_ini = 0
    sum_hubp = 0
    sum_sdl = 0

    filtered_kdas = kdas.filter do |kda|
      kda.week.sprint === current_sprint
    end

    filtered_kdas.each do |kda|
      sum_mot += kda.mot.rating
      sum_p2p += kda.p2p.rating
      sum_ini += kda.ini.rating
      sum_hubp += kda.hubp.rating
      sum_sdl += kda.sdl.rating
    end

    kdas_count = filtered_kdas.count

    # Calculate averages
    avg_mot = kdas_count > 0 ? sum_mot.to_f.round / kdas_count : 0
    avg_p2p = kdas_count > 0 ? sum_p2p.to_f.round / kdas_count : 0
    avg_ini = kdas_count > 0 ? sum_ini.to_f.round / kdas_count : 0
    avg_hubp = kdas_count > 0 ? sum_hubp.to_f.round / kdas_count : 0
    avg_sdl = kdas_count > 0 ? sum_sdl.to_f.round / kdas_count : 0

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

  def calc_yearly_presence(user)
    current_year = Date.today.year
    # start_of_year = Date.new(current_year, 1, 1)
    # FIXME temporary logic for 2024 to only count starting sprint 2, remove for 2025
    start_of_year = Date.new(2024, 5, 3)
    end_of_year = Date.new(current_year, 12, 31)

    yearly_sprints = Sprint.where(start_date: start_of_year..end_of_year)

    earliest_start_date = yearly_sprints.minimum(:start_date)

    date_range = earliest_start_date..Date.today

    absence_count = Attendance.where(user_id: user.id, attendance_date: date_range)
              .where(absence: ['Unjustified Leave', 'Justified Leave', 'Working Away']).count

    present_count = Attendance.where(user_id: user.id, attendance_date: date_range)
    .where(absence: 'Present').count


    if (absence_count == 0 && present_count == 0) || present_count == 0
      presence = 0
    else
      presence = ((present_count.to_f / (present_count + absence_count)) * 100).round
    end

    presence
  end
end
