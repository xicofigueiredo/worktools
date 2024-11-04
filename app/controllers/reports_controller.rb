class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:edit, :update, :update_report_activities, :toggle_hide]


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
    @learner = current_user
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


    if !@report.nil? && @report.user_id == current_user.id
      @hide = @report.hide
    elsif current_user.role == 'parent'
      @hide = @report.hide
    end

  end

  def new
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    @report = current_user.reports.find_or_create_by(sprint: @sprint) do |report|
      report.sprint = @sprint
    end
    redirect_to edit_report_path(@report)

  end

  def edit
    if !@report.nil? && @report.user_id == current_user.id
      @hide = @report.hide
    elsif current_user.role == 'parent'
      @hide = @report.hide
    end

    @timelines = @report.user.timelines.where(hidden: false)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    @learner = @report.user
    @lcs = @learner.hubs.first.users.where(role: 'lc')

    @sprint_goal = current_user.sprint_goals.includes(:knowledges, :skills, :communities).find_by(sprint: @sprint)
    @knowledges = @timelines.joins(:subject).pluck('subjects.name', :personalized_name , :progress, :difference)

    @activities = @sprint_goal.skills.pluck(:extracurricular, :smartgoals)
    @activities += @sprint_goal.communities.pluck(:involved, :smartgoals)
    @report_activities = @report.report_activities

    @activities.each do |activity|
      # Assuming activity[0] is the activity name and activity[1] is the goal
      @report_activities.find_or_create_by(activity: activity[0]) do |report_activity|
        report_activity.goal = activity[1]
      end
    end



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

  def update_report_activities
    # Step 1: Get current activities from sprint goal
    @sprint_goal = current_user.sprint_goals.includes(:skills, :communities).find_by(sprint: @report.sprint)

    # Collect the current activities
    current_activities = []
    @sprint_goal.skills.each do |skill|
      current_activities << { activity: skill.extracurricular, goal: skill.smartgoals }
    end
    @sprint_goal.communities.each do |community|
      current_activities << { activity: community.involved, goal: community.smartgoals }
    end

    # Step 2: Identify existing report activities and delete outdated ones
    # This will delete any ReportActivity that no longer exists in the current_activities list
    @report.report_activities.each do |existing_activity|
      unless current_activities.any? { |activity| activity[:activity] == existing_activity.activity && activity[:goal] == existing_activity.goal }
        existing_activity.destroy
      end
    end

    # Step 3: Repopulate missing activities
    current_activities.each do |activity|
      @report.report_activities.find_or_create_by(activity: activity[:activity]) do |report_activity|
        report_activity.goal = activity[:goal]
      end
    end

    # Redirect back to edit page
    redirect_to edit_report_path(@report), notice: 'Activities updated successfully.'
  end

  def toggle_hide
    @report.update(hide: !@report.hide)
    redirect_to report_path(@report), notice: "Visibility toggled successfully."
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :sprint_id, :general, :lc_comment, :reflection, :sdl, :ini, :mot, :p2p,
      :hubp, :sdl_long_term_plans, :sdl_week_organization, :sdl_achieve_goals, :sdl_study_techniques,
      :sdl_initiative_office_hours, :ini_new_activities, :ini_goal_setting, :mot_integrity, :mot_improvement,
      :p2p_support_from_peers, :p2p_support_to_peers, :hub_cleanliness, :hub_respectful_behavior, :hub_welcome_others,
      :hub_participation,report_activities_attributes: [:id, :activity, :goal, :reflection, :_destroy]
    )
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
