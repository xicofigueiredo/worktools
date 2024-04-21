class LearnerFlagsController < ApplicationController
  before_action :set_learner_flag, only: [:edit, :update]

  def edit
    # View for editing learner flags
  end

  def update
    if @learner_flag.update(learner_flag_params)
      respond_to do |format|
        format.html { redirect_to learner_profile_path(@learner_flag.user), notice: 'Settings were successfully updated.' }
      end
    else
      render :edit
    end
  end

  private

  def set_learner_flag
    @learner_flag = LearnerFlag.find(params[:id])  # Assuming that the form correctly passes the LearnerFlag's ID
  end

  def learner_flag_params
    params.require(:learner_flag).permit(:asks_for_help, :takes_notes, :goes_to_live_lessons, :does_p2p, :action_plan)
  end
end
