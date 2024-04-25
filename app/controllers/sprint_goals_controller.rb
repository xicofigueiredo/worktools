class SprintGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sprint_goal, only: [:update]
  before_action :set_available_sprints, only: [:new]

  # GET /sprint_goals
  def index
    @sprint_goals = current_user.sprint_goals.includes(:sprint, :knowledges, :skills, :communities).order('sprints.start_date DESC')
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @all_sprints = Sprint.all
    ensure_sprint_goal_exists(@date)
    calc_nav_dates(@sprint)
    @has_prev_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @prev_date, @prev_date).present?
    @has_next_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @next_date, @next_date).present?
  end

  # GET /sprint_goals/1
  def show
  end

  # GET /sprint_goals/new
  def new
  end

  # GET /sprint_goals/1/edit
  def edit
    @edit = true
    @sprint_goal = current_user.sprint_goals.find(params[:id])
    # If the @sprint_goal doesn't have associated knowledges for each timeline, you need to build them here
    current_user.timelines.each do |timeline|
      @sprint_goal.knowledges.find_or_initialize_by(subject_name: timeline.subject.name)
    end
    @sprint_goal.skills.build if @sprint_goal.skills.empty?
    @sprint_goal.communities.build if @sprint_goal.communities.empty?
  end

  # POST /sprint_goals
  def create
  end

  # PATCH/PUT /sprint_goals/1
  def update
    if @sprint_goal.update(sprint_goal_params)
      redirect_to sprint_goals_path(date: @sprint_goal.sprint.start_date), notice: 'Sprint goal was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sprint_goals/1
  def destroy
    @sprint_goal.destroy
    redirect_to sprint_goals_url, notice: 'sprint_goal was successfully destroyed.'
  end

  private

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end

  def ensure_sprint_goal_exists(date)
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", date, date)
    return if @sprint.nil?

    @sprint_goal = current_user.sprint_goals.find_or_create_by(sprint: @sprint) do |sg|
      sg.sprint = @sprint
    end
  end

  def set_sprint_goal
    @sprint_goal = SprintGoal.find(params[:id])
  end

  def sprint_goal_params
    params.require(:sprint_goal).permit(:name, :start_date, :end_date, :sprint_id,
                                        knowledges_attributes: [:id, :difficulties, :plan, :_destroy, :subject_name],
                                        skills_attributes: [:id, :extracurricular, :smartgoals, :difficulties, :plan, :_destroy],
                                        communities_attributes: [:id, :involved, :smartgoals, :difficulties, :plan, :_destroy])
  end

end
