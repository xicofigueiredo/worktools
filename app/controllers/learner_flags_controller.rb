class LearnerFlagsController < ApplicationController
  before_action :set_learner_flag, only: %i[edit update]

  def edit
    # View for editing learner flags
  end

  def update
    if @learner_flag.update(learner_flag_params)
      respond_to do |format|
        format.html do
          redirect_to learner_profile_path(@learner_flag.user), notice: 'Settings were successfully updated.'
        end
      end
    else
      render :edit
    end
  end

  private

  def set_learner_flag
    @learner_flag = LearnerFlag.find(params[:id])
  end

  def learner_flag_params
    params.require(:learner_flag).permit(:asks_for_help, :takes_notes, :goes_to_live_lessons, :does_p2p,
                                         :life_experiences, :action_plan)
  end
end
