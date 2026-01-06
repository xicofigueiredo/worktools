class AiSummary < ApplicationRecord
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validates :notes_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :for_date_range, ->(start_date, end_date) { where(start_date: start_date, end_date: end_date) }
end
