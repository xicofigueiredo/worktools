class SprintGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sprint_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_available_sprints, only: [:new, :edit]

  # GET /sprint_goals
  def index
    @sprint_goals = current_user.sprint_goals.includes(:sprint, :knowledges, :skills, :communities).order('sprints.start_date DESC')
  end

  # GET /sprint_goals/1
  def show
    @sprint = @sprint_goal.sprint
  end

  # GET /sprint_goals/new
  def new
    @sprint_goal = current_user.sprint_goals.build
    @sprint_goal = current_user.sprint_goals.build
    current_user.timelines.each do |timeline|
      knowledge = @sprint_goal.knowledges.build
      knowledge.timeline = timeline
    end
    @sprint_goal.skills.build
    @sprint_goal.communities.build
  end

  # GET /sprint_goals/1/edit
  def edit
    @sprint_goal = current_user.sprint_goals.find(params[:id])
    # If the @sprint_goal doesn't have associated knowledges for each timeline, you need to build them here
    current_user.timelines.each do |timeline|
      @sprint_goal.knowledges.find_or_initialize_by(timeline: timeline)
    end
    @sprint_goal.skills.build if @sprint_goal.skills.empty?
    @sprint_goal.communities.build if @sprint_goal.communities.empty?
  end

  # POST /sprint_goals
  def create
    @sprint_goal = current_user.sprint_goals.build(sprint_goal_params)
    if @sprint_goal.save
      redirect_to sprint_goals_path, notice: 'sprint_goal was successfully created.'
    else
      set_available_sprints
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sprint_goals/1
  def update
    if @sprint_goal.update(sprint_goal_params)
      redirect_to @sprint_goal, notice: 'Sprint goal was successfully updated.'
    else
      set_available_sprints
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sprint_goals/1
  def destroy
    @sprint_goal.destroy
    redirect_to sprint_goals_url, notice: 'sprint_goal was successfully destroyed.'
  end

  private

  def set_sprint_goal
    @sprint_goal = SprintGoal.find(params[:id])
  end

  def set_available_sprints
    used_sprints = current_user.sprint_goals.pluck(:sprint_id)
    @available_sprints = Sprint.where.not(id: used_sprints)
  end

  def sprint_goal_params
    params.require(:sprint_goal).permit(:name, :start_date, :end_date, :sprint_id,
                                        knowledges_attributes: [:id, :difficulties, :plan, :_destroy, :timeline_id],
                                        skills_attributes: [:id, :extracurricular, :smartgoals, :difficulties, :plan, :_destroy],
                                        communities_attributes: [:id, :involved, :smartgoals, :difficulties, :plan, :_destroy])
  end

end
