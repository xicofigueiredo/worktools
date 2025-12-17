class CalendarDataService
  attr_reader :year, :hub, :country, :department_id, :type_filter

  def initialize(year:, hub: nil, country: nil, department_id: nil, type_filter: nil, include_visits: false)
    @year = year.to_i
    @hub = hub
    @country = country
    @department_id = department_id
    @type_filter = type_filter
    @include_visits = include_visits

    @start_date = Date.new(@year, 1, 1)
    @end_date   = Date.new(@year, 12, 31)
  end

  def call
    {
      holidays: fetch_holidays,
      blocked: fetch_blocked_periods,
      mandatory: fetch_mandatory_leaves,
      visits: fetch_hub_visits
    }
  end

  private

  def fetch_hub_visits
    return {} unless @include_visits && @hub.present?

    # Fetch pending or confirmed visits for this Hub in this year
    visits = HubVisit.where(hub_id: @hub.id)
                     .where(start_time: @start_date.beginning_of_day..@end_date.end_of_day)
                     .where.not(status: ['cancelled', 'rejected'])

    events = {}
    visits.find_each do |v|
      date = v.start_time.to_date
      (events[date] ||= []) << v
    end
    events
  end

  def fetch_holidays
    return {} if @type_filter == 'blocked'

    scope = if @hub.present?
      PublicHoliday.where(
        "(hub_id = :hub_id) OR (hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
        hub_id: @hub.id, country: @hub.country
      )
    elsif @country.present?
      PublicHoliday.where(
        "(hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
        country: @country
      )
    else
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

    blocks = BlockedPeriod.for_calendar_view(
      start_date: @start_date,
      end_date: @end_date,
      hub_id: @hub&.id,
      department_id: @department_id
    )

    events = {}
    blocks.find_each do |b|
      range_start = [b.start_date, @start_date].max
      range_end   = [b.end_date, @end_date].min

      (range_start..range_end).each do |date|
        (events[date] ||= []) << b
      end
    end
    events
  end

  def fetch_mandatory_leaves
    MandatoryLeave.where("start_date <= ? AND end_date >= ?", @end_date, @start_date)
  end
end
