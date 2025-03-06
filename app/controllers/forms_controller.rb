class FormsController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = Form.current.order(scheduled_date: :desc)
  end

  def show
    @form = Form.find(params[:id])
    @form_interrogations = @form.form_interrogation_joins.includes(:interrogation)

    # Check if user has already responded to any questions
    @existing_responses = {}
    @form.responses_for_user(current_user).each do |response|
      @existing_responses[response.form_interrogation_join_id] = response
    end
  end
end
