class ReportsController < ApplicationController
  before_action :authenticate_user!

  def learner_view
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
    @is_edit = false
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    @report = current_user.reports.find_or_create_by(sprint: @sprint) do |report|
      report.sprint = @sprint
    end
  end

  def edit
    @is_edit = true
    @report = current_user.reports.find(params[:id])
  end


  private

  def report_params
    params.require(:report).permit(:user_id, :sprint_id)
  end

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end

  def current_sprint
    Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)
  end
end
