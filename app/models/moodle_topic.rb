class MoodleTopic < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true

  validates :time, :name, :unit, :order, presence: true
  validates :done, inclusion: { in: [true, false] }

  def moodle_calculate_percentage
    total_time = self.moodle_timeline.moodle_topics.sum(:time).to_f

    # Handle division by zero case
    if total_time == 0
      self.percentage = 0.0
    else
      self.percentage = self.time / total_time
    end
  end
end
