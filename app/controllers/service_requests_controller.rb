class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = ServiceRequest.where(requester: current_user)
                              .or(ServiceRequest.where(learner: current_user))
                              .includes(:learner, :requester, :confirmations)
                              .order(created_at: :desc)
  end

  def create
    # Whitelist allowed STI types for security
    allowed_types = %w[HubTransferRequest CertificateRequest]
    type = params[:service_request][:type]

    unless allowed_types.include?(type)
      redirect_to dashboard_lc_path, alert: "Invalid request type." and return
    end

    # Instantiate the specific child class
    @request = type.constantize.new(request_params)
    @request.requester = current_user
    # Ensure status is pending
    @request.status = 'pending'

    if @request.save
      # Create initial confirmation (optional, based on your pattern)
      # @request.confirmations.create!(...)

      redirect_to dashboard_lc_path(hub_id: params[:hub_id]), notice: "#{type.underscore.humanize} created successfully."
    else
      redirect_to dashboard_lc_path(hub_id: params[:hub_id]), alert: "Error: #{@request.errors.full_messages.to_sentence}"
    end
  end

  private

  def request_params
    params.require(:service_request).permit(
      :type,
      :learner_id,
      :reason,
      :target_hub_id,
      :certificate_type
    )
  end
end
