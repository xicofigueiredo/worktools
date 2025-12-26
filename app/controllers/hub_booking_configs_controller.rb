class HubBookingConfigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hub

  def update
    @config = @hub.booking_config || @hub.build_booking_config

    # Extract and clean raw slots from params
    raw_slots = params.require(:hub_booking_config).permit(visit_slots: {})[:visit_slots]
    clean_slots = {}
    if raw_slots.present?
      raw_slots.each do |day, times|
        valid_times = times.select(&:present?)
        clean_slots[day] = valid_times if valid_times.any?
      end
    end

    @config.visit_slots = clean_slots

    respond_to do |format|
      if @config.save
        format.html { redirect_back fallback_location: calendar_hub_path(@hub), notice: 'Schedule updated successfully.' }
      else
        # Render Turbo Stream to update only the form partial with errors
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("booking_config_form_container",
                               partial: "hub_booking_configs/form",
                               locals: { config: @config, hub: @hub })
        }
        format.html { redirect_back fallback_location: calendar_hub_path(@hub), alert: "Error: #{@config.errors.full_messages.join(', ')}" }
      end
    end
  end

  private

  def set_hub
    @hub = Hub.find(params[:hub_id])
  end
end
