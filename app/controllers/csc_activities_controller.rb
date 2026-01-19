class CscActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_csc_activity

  def edit
  end

  def update
    if @csc_activity.update(csc_activity_params)
      redirect_to csc_diploma_path, notice: "Activity updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_hidden
    @csc_activity.update(hidden: !@csc_activity.hidden)
    redirect_to csc_diploma_path
  end

  private

  def set_csc_activity
    @csc_activity = current_user.csc_diploma.csc_activities.find(params[:id])
  end

  def csc_activity_params
    params.require(:csc_activity).permit(:hours, :weight, :credits, :rubric_score, :validated)
  end
end
