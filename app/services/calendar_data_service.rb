class CalendarDataService
  attr_reader :year, :hub, :country, :department_id, :type_filter

  # 1. Update Initialize to accept country
  def initialize(year:, hub: nil, country: nil, department_id: nil, type_filter: nil)
    @year = year.to_i
    @hub = hub
    @country = country
    @department_id = department_id
    @type_filter = type_filter

    @start_date = Date.new(@year, 1, 1)
    @end_date   = Date.new(@year, 12, 31)
  end

  def call
    {
      holidays: fetch_holidays,
      blocked: fetch_blocked_periods,
      mandatory: fetch_mandatory_leaves
    }
  end

  private

  def fetch_holidays
    return {} if @type_filter == 'blocked'

    # 2. Refactored Scope Logic
    scope = if @hub.present?
      # CASE A: Hub Selected -> Show Hub Specific + Hub's Country + Global
      PublicHoliday.where(
        "(hub_id = :hub_id) OR (hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
        hub_id: @hub.id, country: @hub.country
      )
    elsif @country.present?
      # CASE B: Country Selected (No Hub) -> Show Country Specific + Global
      PublicHoliday.where(
        "(hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
        country: @country
      )
    else
      # CASE C: No Filter -> Show EVERYTHING (Global, Country, and Hub specific)
      PublicHoliday.all
    end

    events = {}
    scope.find_each do |h|
      if h.recurring
        begin
          d = Date.new(@year, h.date.month, h.date.day)
          (events[d] ||= []) << h
        rescue Date::Error; end
      elsif h.date.year == @year
        (events[h.date] ||= []) << h
      end
    end
    events
  end

  def fetch_blocked_periods
    return {} if @type_filter == 'holidays'

    # Use the scope we will add to BlockedPeriod
    blocks = BlockedPeriod.for_calendar_view(
      start_date: @start_date,
      end_date: @end_date,
      hub_id: @hub&.id,
      department_id: @department_id
    )

    events = {}
    blocks.find_each do |b|
      # Expand range into individual date keys for the calendar grid
      range_start = [b.start_date, @start_date].max
      range_end   = [b.end_date, @end_date].min

      (range_start..range_end).each do |date|
        (events[date] ||= []) << b
      end
    end
    events
  end

  def fetch_mandatory_leaves
    # Fetch mandatory leaves overlapping the year
    MandatoryLeave.where("start_date <= ? AND end_date >= ?", @end_date, @start_date)
  end
end
