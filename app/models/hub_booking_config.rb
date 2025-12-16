class HubBookingConfig < ApplicationRecord
  belongs_to :hub

  validates :visit_duration, :trial_duration, numericality: { greater_than: 0 }

  # Virtual attribute to handle comma-separated string from the form
  def visit_slots_str
    (visit_slots || []).join(', ')
  end

  def visit_slots_str=(str)
    self.visit_slots = str.split(',').map(&:strip).reject(&:blank?)
  end

  def open_on?(wday)
    (visit_days || []).include?(wday)
  end
end
