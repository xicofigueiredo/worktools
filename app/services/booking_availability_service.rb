class BookingAvailabilityService
  OPENING_HOUR = 10
  CLOSING_LIMIT_HOUR = 16

  def initialize(hub, date, visit_type)
    @hub = hub
    @date = date.to_date
    @visit_type = visit_type
    @config = @hub.booking_config
  end

  def available_slots
    return [] unless @config && @config.open_on?(@date.wday)
    return [] if is_holiday? || is_blocked?

    # Determine duration (minutes)
    duration = @visit_type == 'trial' ? @config.trial_duration : @config.visit_duration

    limit_time = Time.zone.parse("#{@date} #{CLOSING_LIMIT_HOUR}:00")

    if @visit_type == 'trial'
      limit_time -= duration.minutes
    end

    # Get allowed slots from config (e.g. ["10:00", "14:00"])
    configured_slots = @config.visit_slots || []
    available = []

    configured_slots.each do |time_str|
      start_time = Time.zone.parse("#{@date} #{time_str}")

      # 1. RANGE CHECK: Is this slot too late for the specific type?
      if start_time > limit_time
        next
      end

      # 2. OVERLAP CHECK: Is the slot taken?
      end_time = start_time + duration.minutes
      unless slot_taken?(start_time, end_time)
        available << time_str
      end
    end

    available.sort
  end

  private

  def is_holiday?
    PublicHoliday.where("date = ?", @date)
                 .where("(hub_id = ? OR (hub_id IS NULL AND country = ?))", @hub.id, @hub.country)
                 .exists?
  end

  def is_blocked?
    BlockedPeriod.where(hub_id: @hub.id)
                 .where("start_date <= ? AND end_date >= ?", @date, @date)
                 .exists?
  end

  def slot_taken?(start_t, end_t)
    HubVisit.where(hub_id: @hub.id)
            .where.not(status: ['cancelled', 'rejected'])
            .where("start_time < ? AND end_time > ?", end_t, start_t)
            .exists?
  end
end
