# app/controllers/sprint_goals_controller.rb

class SprintGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sprint_goal, only: [:show, :edit, :update, :destroy]

  # GET /sprint_goals
  def index
    @sprint_goals = current_user.sprint_goals
  end

  # GET /sprint_goals/1
  def show
  end

  # GET /sprint_goals/new
  def new
    @sprint_goal = current_user.sprint_goals.new
  end

  # POST /sprint_goals
  def create
    @sprint_goal = current_user.sprint_goals.new(sprint_goal_params)

    if @sprint_goal.save
      redirect_to @sprint_goal, notice: 'Sprint goal was successfully created.'
    else
      render :new
    end
  end

  # GET /sprint_goals/1/edit
  def edit
  end

  # PATCH/PUT /sprint_goals/1
  def update
    if @sprint_goal.update(sprint_goal_params)
      redirect_to @sprint_goal, notice: 'Sprint goal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sprint_goals/1
  def destroy
    @sprint_goal.destroy
    redirect_to sprint_goals_url, notice: 'Sprint goal was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sprint_goal
    @sprint_goal = current_user.sprint_goals.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sprint_goal_params
    params.require(:sprint_goal).permit(:start_date, :end_date, :other_attributes)
  end
end
