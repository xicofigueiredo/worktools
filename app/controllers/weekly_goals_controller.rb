# app/controllers/weekly_goals_controller.rb

class WeeklyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_subject
  before_action :set_topics

  # GET /weekly_goals
  def index
    @weekly_goals = current_user.weekly_goals
    @time_slots = ["Early Morning", "Morning", "Late Morning", " Early Afternoon", "Afternoon", "Late Afternoon"]
  end

  # GET /weekly_goals/1
  def show
  end

  # GET /weekly_goals/new
  def new
    @weekly_goal = current_user.weekly_goals.new
  end

  # POST /weekly_goals
  def create
    @weekly_goal = current_user.weekly_goals.new(weekly_goal_params)

    if @weekly_goal.save
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully created.'
    else
      render :new
    end
  end

  # GET /weekly_goals/1/edit
  def edit
  end

  # PATCH/PUT /weekly_goals/1
  def update
    if @weekly_goal.update(weekly_goal_params)
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /weekly_goals/1
  def destroy
    @weekly_goal.destroy
    redirect_to weekly_goals_url, notice: 'Weekly goal was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_weekly_goal
    @weekly_goal = current_user.weekly_goals.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def weekly_goal_params
    params.require(:weekly_goal).permit(:start_date, :end_date, :other_attributes)
  end

  def set_subject
    @subjects = current_user.timelines.map(&:subject).uniq
  end

  def set_topics
    @topics = @subjects.flat_map(&:topics).uniq
  end

end
