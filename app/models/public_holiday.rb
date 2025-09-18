class PublicHoliday < ApplicationRecord
  belongs_to :hub, optional: true

  validates :date, presence: true
  validates :name, presence: true

  # returns holiday Date objects for a hub (hub may be nil) inside the given range
  def self.dates_for_range(hub:, start_date:, end_date:)
    return [] if start_date.nil? || end_date.nil? || end_date < start_date

    country = hub&.country
    query = PublicHoliday.where(date: start_date..end_date)
    query = query.where("(hub_id IS NOT NULL AND hub_id = :hub_id) OR (hub_id IS NULL AND country = :country) OR (hub_id IS NULL AND country IS NULL)",
                        hub_id: hub&.id, country: country)
    query.pluck(:date).map(&:to_date).uniq
  end
end
