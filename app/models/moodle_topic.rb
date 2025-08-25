class MoodleTopic < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true

  validates :time, :name, :unit, :order, presence: true
  validates :grade, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :done, inclusion: { in: [true, false] }

  def moodle_calculate_percentage
    total_time = self.moodle_timeline.moodle_topics.sum(:time).to_f
    self.percentage = self.time / total_time
  end
end
