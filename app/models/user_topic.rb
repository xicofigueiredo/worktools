class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :user, :topic, presence: true

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
