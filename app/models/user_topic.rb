class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  belongs_to :timeline, optional: true

  after_save :check_timeline_completion
  after_save :clear_monthly_goals_cache, if: :deadline_changed_for_current_user?

  validates :user, :topic, presence: true
  # validates :deadline, presence: true

  before_save :update_percentage

  def calculate_percentage
    total_time = topic.subject.topics.sum(:time).to_f
    self.percentage = topic.time / total_time
  end

  def update_percentage
    total_time = topic.subject.topics.sum(:time).to_f
    self.percentage = topic.time / total_time
  end

  def check_timeline_completion
    timeline&.check_and_hide_if_completed
  end

  def deadline_changed_for_current_user?
    saved_change_to_deadline?
  end

  def clear_monthly_goals_cache
    Rails.cache.delete("monthly_goals_#{Date.today.beginning_of_month}")
  end
end
