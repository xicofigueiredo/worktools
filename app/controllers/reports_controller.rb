class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:edit, :update, :update_report_progress, :toggle_hide]


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
    @timelines = current_user.timelines.where(hidden: false).order(difference: :asc)
    @reports = current_user.reports.joins(:sprint)
    @all_sprints = Sprint.all
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @all_sprints = Sprint.all
    calc_nav_dates(@sprint)
    @report = current_user.reports.find_or_initialize_by(sprint: @sprint, last_update_check: Date.today)
    @report.save

    @lcs = @learner.hubs.first.users.where(role: 'lc')


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

    if @report

      @sprint_goal = @learner.sprint_goals.includes(:knowledges, :skills, :communities).find_by(sprint: @sprint)

      activities = @sprint_goal.skills.pluck(:extracurricular, :smartgoals)
      activities += @sprint_goal.communities.pluck(:involved, :smartgoals)
      @report_activities = @report.report_activities

      activity_names = activities.map { |activity| activity[0] } # Extracts the name part of each activity

      @report.report_activities.where.not(activity: activity_names).destroy_all

      activities.each do |activity|
        # Assuming activity[0] is the activity name and activity[1] is the goal
        @report_activities.find_or_create_by(activity: activity[0]) do |report_activity|
          report_activity.goal = activity[1]
        end
      end

      @knowledges = @timelines.left_outer_joins(:subject, :exam_date).pluck('subjects.name', :personalized_name, :progress, :difference, 'exam_dates.date')

      @knowledges.each do |data|
        name = data[1] || data[0]

        # Find or initialize a ReportKnowledge record by subject_name
        knowledge_record = @report.report_knowledges.find_or_initialize_by(subject_name: name)

        # Update or set the attributes as necessary
        knowledge_record.progress = data[2]
        knowledge_record.difference = data[3]

        # Set exam_season only if it hasn't been set before
        if knowledge_record.exam_season.nil?
          knowledge_record.exam_season = data[4].is_a?(Date) ? data[4].strftime("%B %Y") : data[4]
        end

        # Save each record individually to persist changes
        knowledge_record.save
      end
    end

    # Optionally, if you want to ensure the main report is saved
    @report.save


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
    @sprint = @report.sprint

    @learner = @report.user
    @lcs = @learner.hubs.first.users.where(role: 'lc')


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

  def update_report_progress
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
      :hub_participation, report_activities_attributes: [:id, :activity, :goal, :reflection, :_destroy],
      report_knowledges_attributes: [:id, :subject_name, :progress, :difference, :exam_season, :grade]
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

  def update_knowledges

  end

end
