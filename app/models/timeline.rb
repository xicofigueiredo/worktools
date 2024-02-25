class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validate :start_date_before_end_date
  validates :subject_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def calculate_total_time
    self.total_time = (self.end_date - self.start_date)
  end

  def start_date_before_end_date
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
