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
    # 1. Basic Checks
    return [] unless @config
    return [] if @date < Date.current

    # 2. Day of Week Check
    return [] unless @config.open_on?(@date.wday)

    # 3. Blockout Checks
    return [] if is_holiday? || is_blocked?

    # 4. Duration & Limits
    duration = (@visit_type == 'trial') ? @config.trial_duration : @config.visit_duration

    # Define the absolute latest a slot can START
    # Visits: Can start up to 16:00
    # Trials: Can start up to (16:00 - duration)
    limit_time = Time.zone.parse("#{@date} #{CLOSING_LIMIT_HOUR}:00")

    if @visit_type == 'trial'
      limit_time -= duration.minutes
    end

    # 5. Slot Calculation
    available = []
    configured_slots = @config.visit_slots || []

    configured_slots.each do |time_str|
      # Parse strictly in the context of the date and Hub's timezone
      start_time = Time.zone.parse("#{@date} #{time_str}") rescue nil
      next unless start_time

      # Filter: Before Opening Hour? (Safety check)
      opening_time = Time.zone.parse("#{@date} #{OPENING_HOUR}:00")
      next if start_time < opening_time

      # Filter: After Closing Limit?
      next if start_time > limit_time

      # Filter: In the past? (for today's bookings)
      next if start_time < Time.zone.now + 1.hour # Buffer for immediate bookings

      # Overlap Check
      end_time = start_time + duration.minutes
      unless slot_taken?(start_time, end_time)
        available << time_str
      end
    end

    available.sort
  end

  private

  def is_holiday?
    PublicHoliday.where(date: @date)
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
