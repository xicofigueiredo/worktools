class BookingAvailabilityService
  OPENING_HOUR = HubBookingConfig::OPENING_HOUR
  CLOSING_LIMIT_HOUR = HubBookingConfig::CLOSING_HOUR

  def initialize(hub, date, visit_type)
    @hub = hub
    @date = date.to_date
    @visit_type = visit_type
    @config = @hub.booking_config
  end

  def available_slots
    return [] unless @config
    return [] if @date < Date.current

    hub_tz = HubVisit::COUNTRY_TIMEZONES[@hub.country] || 'UTC'

    Time.use_zone(hub_tz) do
      # A/B Testing: Target RM (ID 106) gets 36h, others 48h
      lead_hours = (@hub.regional_manager_id == 106) ? 36 : 48
      earliest_allowed_time = calculate_business_lead_time(lead_hours)

      day_slots = @config.slots_for_day(@date.wday)
      # Check if the hub is closed on the target date (Holidays, Blocks, or Mandatory Leave)
      return [] if day_slots.empty? || closed_on?(@date)

      duration = (@visit_type == 'trial') ? HubBookingConfig::TRIAL_DURATION : HubBookingConfig::VISIT_DURATION
      limit_time = Time.zone.parse("#{@date} #{CLOSING_LIMIT_HOUR}:00")
      limit_time -= duration.minutes if @visit_type == 'trial'

      available = []
      day_slots.each do |time_str|
        start_time = Time.zone.parse("#{@date} #{time_str}")
        next unless start_time

        # Business rule: Must be after lead time AND before closing limit
        next if start_time < earliest_allowed_time
        next if start_time > limit_time

        end_time = start_time + duration.minutes
        unless slot_taken?(start_time, end_time)
          available << time_str
        end
      end

      available.sort
    end
  end

  private

  # Checks if the Hub is unavailable for any reason on a specific date
  def closed_on?(check_date)
    is_holiday?(check_date) || is_blocked?(check_date) || is_mandatory_leave?(check_date)
  end

  def calculate_business_lead_time(hours)
    current_time = Time.zone.now
    remaining_hours = hours

    while remaining_hours > 0
      current_time += 1.hour
      # Skip counting hours if it's a weekend or the hub is closed (Holiday/Block/Leave)
      unless current_time.saturday? || current_time.sunday? || closed_on?(current_time.to_date)
        remaining_hours -= 1
      end
    end
    current_time
  end

  def is_holiday?(check_date)
    PublicHoliday.where(date: check_date)
                 .where("(hub_id = ? OR (hub_id IS NULL AND country = ?))", @hub.id, @hub.country)
                 .exists?
  end

  def is_blocked?(check_date)
    BlockedPeriod.where(hub_id: @hub.id)
                 .where("start_date <= ? AND end_date >= ?", check_date, check_date)
                 .exists?
  end

  def is_mandatory_leave?(check_date)
    MandatoryLeave.where("start_date <= ? AND end_date >= ?", check_date, check_date).exists?
  end

  def slot_taken?(start_t, end_t)
    HubVisit.where(hub_id: @hub.id)
            .where.not(status: ['cancelled', 'rejected'])
            .where("start_time < ? AND end_time > ?", end_t, start_t)
            .exists?
  end
end
