# app/controllers/forms_controller.rb
class FormsController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = Form.current.order(scheduled_date: :desc)
  end

  def show
    @form = Form.find(params[:id])
    @form_interrogations = @form.form_interrogation_joins.includes(:interrogation)
    @existing_responses = @form.responses_for_user(current_user).index_by(&:form_interrogation_join_id)
  end
end
