class ConfirmationsController < ApplicationController
  before_action :authenticate_user!

  def approve
    @confirmation = current_user.confirmations.find(params[:id])
    @confirmable = @confirmation.confirmable

    if @confirmation.update(status: 'approved', validated_at: Time.current)
      count_pending_confirmations
      prepare_turbo_data
      respond_to { |format| format.turbo_stream }
    end
  end

  def reject
    @confirmation = current_user.confirmations.find(params[:id])
    @confirmable = @confirmation.confirmable
    reason = params[:rejection_reason].to_s.strip

    if @confirmation.update(status: 'rejected', validated_at: Time.current, rejection_reason: reason)
      count_pending_confirmations
      prepare_turbo_data
      respond_to { |format| format.turbo_stream }
    end
  end

  private

  def prepare_turbo_data
    if @confirmable.is_a?(StaffLeave)
      @pending_confirmations = current_user.confirmations.pending.where(confirmable_type: 'StaffLeave')
    else
      types = ['ServiceRequest'] + ServiceRequest::TYPES
      @manager_pending = current_user.confirmations.pending.where(confirmable_type: types)
    end
  end
end
