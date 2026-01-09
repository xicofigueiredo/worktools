class HubVisitsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :available_slots]

  layout 'public'

  def new
    @hub = Hub.find(params[:hub_id])
    @visit = HubVisit.new

    # FETCH ALLOWED DAYS (Integers: 0=Sun, 1=Mon, etc.)
    # If no config, default to empty (calendar will be disabled)
    @allowed_days = @hub.booking_config&.visit_days || []

    # --- BLACKOUT DATES CALCULATION ---
    start_range = Date.current
    end_range = 6.months.from_now.to_date

    @blackout_dates = []

    # 1. Fetch Holidays (Hub-specific, Country-specific, or Global)
    holidays = PublicHoliday.where(date: start_range..end_range)
                            .where("(hub_id = :hub_id) OR (hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
                                   hub_id: @hub.id, country: @hub.country)
    @blackout_dates += holidays.pluck(:date).map(&:to_s)

    # 2. Fetch Blocked Periods (Hub-specific)
    blocks = BlockedPeriod.where(hub_id: @hub.id)
                          .where("start_date <= ? AND end_date >= ?", end_range, start_range)

    blocks.find_each do |block|
      s = [block.start_date, start_range].max
      e = [block.end_date, end_range].min
      @blackout_dates += (s..e).map(&:to_s)
    end

    # 3. Fetch Mandatory Leaves (Global/System-wide)
    mandatory = MandatoryLeave.where("start_date <= ? AND end_date >= ?", end_range, start_range)

    mandatory.find_each do |m|
      s = [m.start_date, start_range].max
      e = [m.end_date, end_range].min
      @blackout_dates += (s..e).map(&:to_s)
    end

    @blackout_dates.uniq!
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

    duration_minutes = if params[:hub_visit][:visit_type] == 'trial'
                       HubBookingConfig::TRIAL_DURATION
                     else
                       HubBookingConfig::VISIT_DURATION
                     end

    @visit = @hub.hub_visits.new(visit_params)

    if params[:date].present? && params[:time].present?
      hub_tz = HubVisit::COUNTRY_TIMEZONES[@hub.country] || 'UTC'
      Time.use_zone(hub_tz) do
        start_time = Time.zone.parse("#{params[:date]} #{params[:time]}")
        @visit.start_time = start_time
        @visit.end_time = start_time + duration_minutes.minutes
      end
    end

    if @visit.save
      if @visit.visit?
        UserMailer.hub_visit_confirmation(@visit).deliver_later
      elsif @visit.trial?
        UserMailer.trial_day_confirmation(@visit).deliver_later
      end

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
