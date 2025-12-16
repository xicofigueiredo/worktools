class HubVisitsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :available_slots]

  layout 'application'

  def new
    @hub = Hub.find(params[:hub_id])
    @visit = HubVisit.new
  end

  def available_slots
    @hub = Hub.find(params[:hub_id])
    date = Date.parse(params[:date]) rescue nil
    visit_type = params[:visit_type]

    if date && visit_type
      service = BookingAvailabilityService.new(@hub, date, visit_type)
      slots = service.available_slots
      render json: { slots: slots }
    else
      render json: { slots: [], error: "Invalid parameters" }, status: :unprocessable_entity
    end
  end

  def create
    @hub = Hub.find(params[:hub_id])
    config = @hub.booking_config

    duration = params[:hub_visit][:visit_type] == 'trial' ? config&.trial_duration : config&.visit_duration
    duration ||= 60

    date_str = params[:date]
    time_str = params[:time]

    @visit = @hub.hub_visits.new(visit_params)

    if date_str.present? && time_str.present?
      start_time = Time.zone.parse("#{date_str} #{time_str}")
      @visit.start_time = start_time
      @visit.end_time = start_time + duration.minutes
    end

    if @visit.save
      # Trigger mailer: HubVisitMailer.confirmation(@visit).deliver_later
      render json: { success: true, message: "Booking Request Sent!" }
    else
      render json: { success: false, errors: @visit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def visit_params
    params.require(:hub_visit).permit(
      :visit_type, :first_name, :last_name, :email, :phone,
      :learner_name, :learner_age, :learner_academic_level, :special_requests
    )
  end
end
