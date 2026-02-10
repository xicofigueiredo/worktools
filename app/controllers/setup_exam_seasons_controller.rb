class SetupExamSeasonsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_exams_or_admin!
  before_action :load_season

  # Settings for the current exam season (driven by the same date/season
  # navigation already used on exam enrollments).
  def edit
  end

  def update
    if @setup_exam_season.update(setup_exam_season_params)
      redirect_to exam_enrolls_path(date: @season[:start_date]),
                  notice: 'Exam season settings were successfully updated.'
    else
      flash.now[:alert] = 'There was a problem saving the exam season settings.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def authorize_exams_or_admin!
    return if current_user.role.in?(%w[exams admin])

    redirect_to root_path, alert: "You don't have permission to manage exam season settings."
  end

  # Uses the same season navigation logic as ExamEnrollsController#index.
  # We always operate on the season the user is already in.
  def load_season
    target_date =
      if params[:date].present?
        begin
          Date.parse(params[:date])
        rescue ArgumentError
          Date.current
        end
      else
        Date.current
      end

    @season = Sprint.find_season_for_date(target_date) || Sprint.current_season
    @setup_exam_season = SetupExamSeason.for_season(@season)
  end

  def setup_exam_season_params
    params.require(:setup_exam_season).permit(
      :pearson_refund,
      :triple_late_fees,
      :bga_refund,
      :mock_submission_with_extension,
      :mock_submission_deadline,
      :extension_request_deadline,
      :late_registration,
      :registration_deadline
    )
  end
end
