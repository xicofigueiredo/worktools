class ReportsController < ApplicationController
  before_action :authenticate_user!

  def learner_view
    @current_sprint = Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)

    if @current_sprint
      @report = Report.find_or_create_by(user_id: current_user.id, sprint_id: @current_sprint.id)
    else
      # Handle the case where there is no current sprint
      flash[:alert] = "No active sprint found for today's date."
      redirect_to some_path # Replace with the path you want to redirect to
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :sprint_id)
  end
end
