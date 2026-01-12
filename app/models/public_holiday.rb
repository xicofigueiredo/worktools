class PublicHoliday < ApplicationRecord
  belongs_to :hub, optional: true

  validates :date, presence: true
  validates :name, presence: true

  # returns holiday Date objects for a hub (hub may be nil) inside the given range
  def self.dates_for_range(hub:, start_date:, end_date:)
    return [] if start_date.nil? || end_date.nil? || end_date < start_date

    country = hub&.country

    # Base relation scoped by hub / country
    rel = PublicHoliday.where(
      "(hub_id IS NOT NULL AND hub_id = :hub_id) OR (hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
      hub_id: hub&.id, country: country
    )

    # 1) explicit holidays
    explicit_dates = rel.where(date: start_date..end_date).pluck(:date).map(&:to_date)

    # 2) recurring holidays
    recurring_month_day_pairs = rel.where(recurring: true).pluck(:date).map { |d| [d.month, d.day] }.uniq

    recurring_dates = recurring_month_day_pairs.flat_map do |month, day|
      (start_date.year..end_date.year).each_with_object([]) do |yr, arr|
        begin
          d = Date.new(yr, month, day)
          arr << d if d >= start_date && d <= end_date
        rescue ArgumentError
          # skip invalid dates like Feb 29 on non-leap years
        end
      end
    end

    (explicit_dates + recurring_dates).uniq.sort
  end

  def self.is_holiday_on?(date, hub)
    country = hub&.country
    rel = where("(hub_id = :h_id) OR (hub_id IS NULL AND country = :c) OR (hub_id IS NULL AND country IS NULL)",
                h_id: hub&.id, c: country)

    rel.where(date: date).exists? ||
    rel.where(recurring: true)
      .where("EXTRACT(MONTH FROM date) = ? AND EXTRACT(DAY FROM date) = ?", date.month, date.day)
      .exists?
  end
end
