# app/controllers/forms_controller.rb
# app/controllers/forms_controller.rb
class FormsController < ApplicationController
  before_action :authenticate_user!

  def index
    # For learners, show all current forms
    # For other roles, keep the subject-based filtering
    if current_user.role == 'learner'
      @forms = Form.current.order(:scheduled_date)
    else
      # Fetch subject names for the current user where timelines are not hidden
      subject_names = current_user.timelines.where(hidden: false).includes(:subject).map { |t| t.subject.name }.uniq

      # Fetch forms based on subject names and order by scheduled date
      @forms = Form.current.by_subject_name(subject_names).order(:scheduled_date)
    end

    # Preload responses for the current user to avoid N+1 queries
    @user_responses = Response.joins(form_interrogation_join: :form)
                              .where(user_id: current_user.id, form_interrogation_joins: { form_id: @forms.pluck(:id) })
                              .index_by { |response| response.form_interrogation_join.form_id }

  end
end
