module WorkingDaysAndHolidays
  extend ActiveSupport::Concern

  def calculate_holidays_array(timeline)
    user_holidays ||= timeline.user.holidays.flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
    bga_holidays ||= Holiday.where(bga: true).flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
    hub_holidays ||= Holiday.where(country: timeline.user.users_hubs.find_by(main: true)&.hub.country).flat_map do |holiday|
      (holiday.start_date..holiday.end_date).to_a
    end
    build_weeks ||= Week.where("name ILIKE ?", "%Build Week%").flat_map { |week| (week.start_date..week.end_date).to_a }

    @holidays_array = (user_holidays + bga_holidays + hub_holidays + build_weeks).uniq
  end

  # Works for timeline as well as sprint and week as long as model has start and end date
  # If you want to check working days for any given timefram you can use a new instance of Timeframe
  # To do so initialize Timeframe.new(<start_date>, <end_date>) and use it as the arg
  def calculate_working_days(timeline)
    calculate_holidays_array(timeline)
    (timeline.start_date..timeline.end_date).to_a.reject do |date|
      @holidays_array.include?(date) || date.saturday? || date.sunday?
    end
  end
end
