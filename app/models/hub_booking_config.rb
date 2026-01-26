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
    # Filter only days that have actual slots selected
    current_slots = visit_slots || {}
    open_days = current_slots.select { |_, slots| slots.present? && slots.any? }

    # Rule 1: At least 3 days must have slots
    if open_days.keys.count < 3
      errors.add(:visit_slots, "must have at least 3 days configured.")
    end

    # Rule 2: At least 30 slots total (distributed across all days)
    total_slots = open_days.values.flatten.count
    if total_slots < 30
      errors.add(:visit_slots, "must have at least 30 slots selected in total (currently #{total_slots}).")
    end

    # Rule 3: At least 2 of the selected days must have 9 or more slots
    days_with_nine_plus = open_days.count { |_, slots| slots.count >= 9 }
    if days_with_nine_plus < 2
      errors.add(:visit_slots, "must include at least 2 days with 9 or more slots.")
    end
  end
end
