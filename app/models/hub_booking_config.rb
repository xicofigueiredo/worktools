class HubBookingConfig < ApplicationRecord
  belongs_to :hub

  VISIT_DURATION = 60
  TRIAL_DURATION = 180

  OPENING_HOUR = 10
  CLOSING_HOUR = 16

  # Returns array of time strings for a given day index (0=Sun, 1=Mon...)
  def slots_for_day(wday)
    return [] unless visit_slots.present?
    visit_slots[wday.to_s] || []
  end

  # Check if a day has ANY slots configured
  def open_on?(wday)
    slots_for_day(wday).any?
  end

  # Returns list of integer weekdays that have slots (for the calendar frontend)
  def visit_days
    return [] unless visit_slots.present?
    visit_slots.keys.map(&:to_i).sort
  end
end
