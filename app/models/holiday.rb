class Holiday < ApplicationRecord
  belongs_to :user, optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date
  validate :dates_cannot_inside_timeline

  def calculate_number_of_days
    self.number_days = (end_date - start_date).to_i + 1
  end

  def start_date_before_end_date
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def dates_cannot_inside_timeline
    user.timelines.each do |timeline|
      if start_date >= timeline.start_date && end_date <= timeline.end_date
        errors.add(:base, "Holiday cannot be inside a timeline")
      end
    end
  end
end
