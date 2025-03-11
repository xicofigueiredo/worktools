# app/controllers/responses_controller.rb
class ResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form, only: [:new, :create, :edit, :update]
  before_action :set_response, only: [:edit, :update]

  def new
    @form_interrogations = @form.form_interrogation_joins.includes(:interrogation)
    @existing_responses = @form.responses_for_user(current_user).index_by(&:form_interrogation_join_id)
  end

  def create
    if params[:responses].present?
      params[:responses].each do |join_id, content|
        next if content.blank?

        response = Response.find_or_initialize_by(
          form_interrogation_join_id: join_id,
          user_id: current_user.id
        )

        response.content = content
        response.save
      end

      redirect_to forms_path, notice: "Your responses have been recorded. Thank you!"
    else
      redirect_to form_path(@form), alert: "Please provide at least one response."
    end
  end

  def edit
    @form_interrogations = @form.form_interrogation_joins.includes(:interrogation)
    @existing_responses = @form.responses_for_user(current_user).index_by(&:form_interrogation_join_id)
  end

  def update
    if params[:responses].present?
      params[:responses].each do |join_id, content|
        next if content.blank?

        response = Response.find_or_initialize_by(
          form_interrogation_join_id: join_id,
          user_id: current_user.id
        )

        response.content = content
        response.save
      end

      redirect_to forms_path, notice: "Your responses have been updated. Thank you!"
    else
      redirect_to form_path(@form), alert: "Please provide at least one response."
    end
  end

  private

  def set_form
    @form = Form.find(params[:form_id])
  end

  def set_response
    @response = Response.find_by(form_interrogation_join_id: params[:id], user_id: current_user.id)
  end
end
