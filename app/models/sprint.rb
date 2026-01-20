class Sprint < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, presence: true

  has_many :sprint_goals, dependent: :destroy
  has_many :weeks, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :consents, dependent: :nullify

  # Season-related class methods
  def self.current_season
    find_season_for_date(Date.current)
  end

  def self.find_season_for_date(date)
    year = date.year

    # Define the 3 seasons for the year
    seasons = [
      { name: "January #{year}", start_date: Date.new(year, 1, 1), end_date: Date.new(year, 1, 31) },
      { name: "May/June #{year}", start_date: Date.new(year, 5, 1), end_date: Date.new(year, 6, 30) },
      { name: "Oct/Nov #{year}", start_date: Date.new(year, 10, 1), end_date: Date.new(year, 11, 30) }
    ]

    # Find which season the date falls into
    current_season = seasons.find { |season| date >= season[:start_date] && date <= season[:end_date] }

    # If no season found in current year, check if it's late December (should be January of next year)
    if current_season.nil? && date.month == 12
      next_year = year + 1
      current_season = { name: "January #{next_year}", start_date: Date.new(next_year, 1, 1), end_date: Date.new(next_year, 1, 31) }
    end

    # If still no season, default to the closest upcoming season
    if current_season.nil?
      if date.month < 5
        current_season = seasons[1] # May/June
      elsif date.month < 10
        current_season = seasons[2] # Oct/Nov
      else
        next_year = year + 1
        current_season = { name: "January #{next_year}", start_date: Date.new(next_year, 1, 1), end_date: Date.new(next_year, 1, 31) }
      end
    end

    current_season
  end

  def self.previous_season(current_season_data)
    current_start = current_season_data[:start_date]
    year = current_start.year

    if current_start.month == 1 # January season
      # Previous is Oct/Nov of previous year
      prev_year = year - 1
      { name: "Oct/Nov #{prev_year}", start_date: Date.new(prev_year, 10, 1), end_date: Date.new(prev_year, 11, 30) }
    elsif current_start.month == 5 # May/June season
      # Previous is January of same year
      { name: "January #{year}", start_date: Date.new(year, 1, 1), end_date: Date.new(year, 1, 31) }
    elsif current_start.month == 10 # Oct/Nov season
      # Previous is May/June of same year
      { name: "May/June #{year}", start_date: Date.new(year, 5, 1), end_date: Date.new(year, 6, 30) }
    end
  end

  def self.next_season(current_season_data)
    current_start = current_season_data[:start_date]
    year = current_start.year

    if current_start.month == 1 # January season
      # Next is May/June of same year
      { name: "May/June #{year}", start_date: Date.new(year, 5, 1), end_date: Date.new(year, 6, 30) }
    elsif current_start.month == 5 # May/June season
      # Next is Oct/Nov of same year
      { name: "Oct/Nov #{year}", start_date: Date.new(year, 10, 1), end_date: Date.new(year, 11, 30) }
    elsif current_start.month == 10 # Oct/Nov season
      # Next is January of next year
      next_year = year + 1
      { name: "January #{next_year}", start_date: Date.new(next_year, 1, 1), end_date: Date.new(next_year, 1, 31) }
    end
  end

  # Returns an array of exam_season values that match the season
  # Used to query ExamFinance records since display_exam_date uses "%B %Y" format
  # e.g., "May/June 2026" -> ["May 2026", "June 2026"]
  # e.g., "Oct/Nov 2026" -> ["October 2026", "November 2026"]
  # e.g., "January 2026" -> ["January 2026"]
  def self.exam_season_matches(season_data)
    current_start = season_data[:start_date]
    year = current_start.year

    if current_start.month == 1 # January season
      ["January #{year}"]
    elsif current_start.month == 5 # May/June season
      ["May #{year}", "June #{year}"]
    elsif current_start.month == 10 # Oct/Nov season
      ["October #{year}", "November #{year}"]
    else
      [season_data[:name]]
    end
  end

  def count_absences(user)
    date_range = start_date..end_date

    Attendance.where(user_id: user.id, attendance_date: date_range)
              .where(absence: 'Unjustified Leave').count
  end

  def count_weekly_goals_total(user)
    date_range = start_date..Date.today

    weekly_goals_count = WeeklyGoal.joins(:week).where(user:, weeks: { start_date: date_range }).count

    passed_weeks_in_sprint_count = Week.where(start_date: date_range).count

    if weekly_goals_count.zero? || passed_weeks_in_sprint_count.zero?
      0
    else
      (weekly_goals_count.to_f / passed_weeks_in_sprint_count * 100).round
    end
  end

  def count_kdas_total(user)
    date_range = start_date..Date.today

    kdas_count = Kda.joins(:week).where(user:, weeks: { start_date: date_range }).count

    passed_weeks_in_sprint_count = Week.where(start_date: date_range).count

    kdas_count.zero? ? 0 : (kdas_count / passed_weeks_in_sprint_count.to_f * 100).round
  end

  def count_weekly_progress_average(user)
    week_averages = weeks.where('start_date < ?', Date.today).map do |week|
      average = week.calc_user_average_timeline_progress(user)
      # FIXME: The logic below is temporary and can be removed after Sprint 2
      average > 10 || average.negative? ? 0 : average
    end

    # Calculate the average of all week averages if there are any weeks
    if week_averages.any?
      overall_average = week_averages.compact.sum / week_averages.compact.size
      overall_average.round(1) # rounding the result to one decimal place
    else
      0 # Return 0 if there are no weeks or all weeks returned nil
    end
  end
end
