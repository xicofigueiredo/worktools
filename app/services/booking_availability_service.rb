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
    # 1. Basic Checks
    return [] unless @config
    return [] if @date < Date.current

    # 2. Get Configured Slots for THIS specific day (1=Mon, etc)
    day_slots = @config.slots_for_day(@date.wday)

    # If no slots for this day, we are closed
    return [] if day_slots.empty?

    # 3. Blockout Checks
    return [] if is_holiday? || is_blocked? || is_mandatory_leave?

    # 4. Duration & Limits (Using Constants)
    duration = (@visit_type == 'trial') ? HubBookingConfig::TRIAL_DURATION : HubBookingConfig::VISIT_DURATION

    limit_time = Time.zone.parse("#{@date} #{CLOSING_LIMIT_HOUR}:00")
    limit_time -= duration.minutes if @visit_type == 'trial'

    # 5. Slot Calculation
    available = []

    day_slots.each do |time_str|
      start_time = Time.zone.parse("#{@date} #{time_str}") rescue nil
      next unless start_time

      # Filter: Before Opening/After Limit/In Past
      opening_time = Time.zone.parse("#{@date} #{OPENING_HOUR}:00")
      next if start_time < opening_time
      next if start_time > limit_time
      next if start_time < Time.zone.now + 24.hours

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

  def is_mandatory_leave?
    MandatoryLeave.where("start_date <= ? AND end_date >= ?", @date, @date).exists?
  end

  def slot_taken?(start_t, end_t)
    HubVisit.where(hub_id: @hub.id)
            .where.not(status: ['cancelled', 'rejected'])
            .where("start_time < ? AND end_time > ?", end_t, start_t)
            .exists?
  end
end
