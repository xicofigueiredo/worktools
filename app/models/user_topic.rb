class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  belongs_to :timeline, optional: true

  after_save :check_timeline_completion

  validates :user, :topic, presence: true
  # validates :deadline, presence: true

  before_save :update_percentage

  def calculate_percentage
    total_time = self.topic.subject.topics.sum(:time).to_f
    self.percentage = self.topic.time / total_time
  end

  def update_percentage
    total_time = self.topic.subject.topics.sum(:time).to_f
    self.percentage = self.topic.time / total_time
  end

  def check_timeline_completion
    timeline.check_and_hide_if_completed
  end

end
