class MoodleTopic < ApplicationRecord
  belongs_to :timeline

  validates :time, :name, :unit, :order, presence: true
  validates :grade, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :done, inclusion: { in: [true, false] }
end
