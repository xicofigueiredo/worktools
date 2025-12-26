class HubBookingConfig < ApplicationRecord
  belongs_to :hub

  validate :validate_minimum_schedule

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

  private

  def validate_minimum_schedule
    return if visit_slots.blank?

    # At least 3 days must have slots
    open_days = visit_slots.select { |_, slots| slots.present? && slots.any? }
    if open_days.keys.count < 3
      errors.add(:visit_slots, "must have at least 3 days configured.")
    end

    # Any open day must have at least 9 slots
    open_days.each do |day, slots|
      if slots.count < 9
        day_name = Date::DAYNAMES[day.to_i]
        errors.add(:visit_slots, "for a selected day must have at least 9 slots selected.")
      end
    end
  end
end
