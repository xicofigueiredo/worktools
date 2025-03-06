class ResponsesController < ApplicationController
  before_action :authenticate_user!

  def create
    @form = Form.find(params[:form_id])

    if params[:responses].present?
      # Process each response
      params[:responses].each do |join_id, content|
        next if content.blank?

        # Find or create response
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
end
