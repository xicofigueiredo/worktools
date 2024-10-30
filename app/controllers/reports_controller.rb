class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:edit, :update]


  def lc_view
    @current_sprint = Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)

    if @current_sprint
      @report = Report.find_or_create_by(user_id: current_user.id, sprint_id: @current_sprint.id)
    else
      # Handle the case where there is no current sprint
      flash[:alert] = "No active sprint found for today's date."
      redirect_to some_path # Replace with the path you want to redirect to
    end
  end

  def index
    @timelines = current_user.timelines.where(hidden: false)
    @reports = current_user.reports.joins(:sprint)
    @all_sprints = Sprint.all
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @all_sprints = Sprint.all
    calc_nav_dates(@sprint)

    if @sprint
      @report = current_user.reports.find_by(sprint: @sprint)

    else
      @report = nil
    end

    @has_prev_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @prev_date, @prev_date).present?
    @has_next_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @next_date, @next_date).present?
    @edit = false
  end

  def new
    @timelines = current_user.timelines.where(hidden: false)
    @is_edit = false
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @skills = @report.user.sprint_goals.find_by(sprint: @sprint).skills
    @communities = @report.user.sprint_goals.find_by(sprint: @sprint).communities

    @report = current_user.reports.find_or_create_by(sprint: @sprint) do |report|
      report.sprint = @sprint
    end
  end

  def edit
    @is_edit = true
    @timelines = @report.user.timelines.where(hidden: false)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @skills = @report.user.sprint_goals.find_by(sprint: @sprint).skills
    @communities = @report.user.sprint_goals.find_by(sprint: @sprint).communities
    @learner = @report.user

    # Check if the current user has access to edit the report
    if current_user.role == 'learner' && @report.user_id == current_user.id
      # The learner can edit their report
      @role = 'learner'
    elsif current_user.role == 'lc' && (current_user.hubs & @report.user.hubs).any?
      # The LC can edit the report related to them
      @role = 'lc'
    elsif current_user.role == 'admin'
      # The admin can edit any report
      @role = 'learner'
    else
      # Handle unauthorized access, e.g., redirect or show an error
      redirect_to root_path, alert: 'You do not have permission to edit this report.'
    end
  end

  def update
    if @report.update(report_params)
      redirect_to reports_path, notice: 'Report was successfully updated.'
    else
      render :edit
    end
  end


  private

  def report_params
    params.require(:report).permit(:user_id, :sprint_id, :general, :lc_comment, :reflection, :sdl, :ini, :mot, :p2p, :hubp)
  end

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end

  def current_sprint
    Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)
  end

  def set_report
    @report = Report.find(params[:id])
  end
end
