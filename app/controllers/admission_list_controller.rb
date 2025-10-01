class AdmissionListController < ApplicationController
  # Add permissions

  def index
    @learner_infos = LearnerInfo.includes(:user).order(:id)

    # Columns to display - exclude internal fields
    excluded = %w[id user_id created_at updated_at]
    @columns = LearnerInfo.column_names - excluded

    @columns.unshift('user_email')
  end

  def show
    @learner_info = LearnerInfo.includes(:user).find(params[:id])
    excluded = %w[id user_id created_at updated_at]
    @show_columns = LearnerInfo.column_names - excluded
  end
end
