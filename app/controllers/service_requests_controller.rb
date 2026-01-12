# app/controllers/service_requests_controller.rb
class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hub_and_options, only: [:index, :create]

  def index
    @requests = ServiceRequest.where(requester: current_user)
                              .includes(:learner, confirmations: :approver)
                              .order(created_at: :desc)

    confirmations_scope = current_user.confirmations.where(confirmable_type: ['ServiceRequest'] + ServiceRequest::TYPES)

    @manager_pending = confirmations_scope.pending.includes(confirmable: [:learner, :requester])
    @review_history = confirmations_scope.where.not(status: 'pending')
                                        .includes(confirmable: :learner)
                                        .order(validated_at: :desc)

    # Pre-load learners for the user's main hub
    @main_hub = current_user.main_hub
    @users = @main_hub ? @main_hub.users.where(role: 'learner', deactivate: [false, nil]).order(:full_name) : []
  end

  def fetch_learners
    # Restrict fetching to only hubs the user actually belongs to
    @hub = current_user.hubs.find_by(id: params[:hub_id])
    @users = @hub ? @hub.users.where(role: 'learner', deactivate: [false, nil]).order(:full_name) : []

    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    type = params[:service_request][:type]
    unless ServiceRequest::TYPES.include?(type)
      redirect_to service_requests_path, alert: "Invalid request type." and return
    end

    @request = type.constantize.new(request_params)
    @request.requester = current_user
    @request.status = 'pending'

    if @request.save
      redirect_to service_requests_path, notice: "#{type.underscore.humanize.titleize} submitted successfully."
    else
      @requests = ServiceRequest.where(requester: current_user)
      flash.now[:alert] = "Request failed: #{@request.errors.full_messages.to_sentence}"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_hub_and_options
    @user_hubs = current_user.hubs.order(:name)
    @hub_options = Hub.order(:name).map { |h| [h.name, h.id] }
  end

  def request_params
    params.require(:service_request).permit(
      :type, :learner_id, :reason, :target_hub_id, :certificate_type
    )
  end
end
