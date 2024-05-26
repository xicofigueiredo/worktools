class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  belongs_to :timeline, optional: true

  validates :user, :topic, presence: true
  validates :deadline, presence: true

  before_save :update_percentage

  def calculate_percentage
    total_time = self.topic.subject.topics.sum(:time).to_f
    self.percentage = self.topic.time / total_time
  end

  def update_percentage
    total_time = self.topic.subject.topics.sum(:time).to_f
    self.percentage = self.topic.time / total_time
  end
end
