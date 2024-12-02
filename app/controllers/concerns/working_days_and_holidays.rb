module WorkingDaysAndHolidays
  extend ActiveSupport::Concern

  def calculate_holidays_array
    user_holidays ||= current_user.holidays.flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
    bga_holidays ||= Holiday.where(bga: true).flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
    hub_holidays ||= Holiday.where(country: current_user.users_hubs.first.hub.country).flat_map do |holiday|
      (holiday.start_date..holiday.end_date).to_a
    end

    @holidays_array = (user_holidays + bga_holidays + hub_holidays).uniq
  end

  # Works for timeline as well as sprint and week as long as model has start and end date
  # If you want to check working days for any given timefram you can use a new instance of Timeframe
  # To do so initialize Timeframe.new(<start_date>, <end_date>) and use it as the arg
  def calculate_working_days(timeframe)
    calculate_holidays_array
    (timeframe.start_date..timeframe.end_date).to_a.reject do |date|
      @holidays_array.include?(date) || date.saturday? || date.sunday?
    end
  end
end
