class HubBookingConfigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hub

  def update
    @config = @hub.booking_config || @hub.build_booking_config

    # Convert checkbox strings to integers
    if params[:hub_booking_config][:visit_days].present?
      params[:hub_booking_config][:visit_days] = params[:hub_booking_config][:visit_days].map(&:to_i)
    end

    # Clean empty slots
    if params[:hub_booking_config][:visit_slots].present?
      params[:hub_booking_config][:visit_slots].reject!(&:blank?)
    end

    if @config.update(config_params)
      redirect_back fallback_location: calendar_hub_path(@hub), notice: 'Booking settings updated successfully.'
    else
      redirect_back fallback_location: calendar_hub_path(@hub), alert: "Error updating settings: #{@config.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_hub
    @hub = Hub.find(params[:hub_id])
  end

  def config_params
    # Removed closing_time from permitted params
    params.require(:hub_booking_config).permit(
      :visit_duration, :trial_duration,
      visit_days: [], visit_slots: []
    )
  end
end
