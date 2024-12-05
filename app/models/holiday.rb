class Holiday < ApplicationRecord
  belongs_to :user, optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date
  validate :holiday_duration_within_limit

  def calculate_number_of_days
    self.number_days = (end_date - start_date).to_i + 1
  end

  def start_date_before_end_date
    return unless start_date && end_date && start_date > end_date

    errors.add(:end_date, "must be after the start date")
  end

  def holiday_duration_within_limit
    return unless start_date && end_date

    max_duration = 5.months
    if end_date > start_date + max_duration
      errors.add(:end_date, "must not exceed 5 months from the start date")
    end
  end
end
