class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true

  after_create :create_user_topics
  after_save :clear_monthly_goals_cache, if: :dates_changed?

  has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_user_topics
  belongs_to :exam_date, optional: true
  belongs_to :lws_timeline, optional: true
  has_many :user_topics
  has_many :topics, through: :user_topics
  has_many :timeline_progresses, dependent: :destroy
  has_many :weeks, through: :timeline_progresses

  validate :start_date_before_end_date
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_cannot_be_holidays

  def check_and_hide_if_completed
    return unless user_topics.all?(&:done)

    update(hidden: true)
  end

  def create_user_topics
    subject.topics.order(:order).find_each do |topic|
      user.user_topics.create!(topic:, done: false)
    end
  end

  def calculate_total_time
    self.total_time = (end_date - start_date)
  end

  def start_date_before_end_date
    return unless start_date && end_date && start_date >= end_date

    errors.add(:end_date, "must be after the start date")
  end

  def destroy_associated_user_topics
    user.user_topics.joins(:topic).where(topics: { subject_id: }).destroy_all
  end

  def update_weekly_progress(week)
    tp = timeline_progresses.find_or_initialize_by(week:)
    tp.progress = progress
    tp.save!
  end

  def dates_cannot_be_holidays
    holidays = user.holidays
    return unless holidays.include?(start_date) && holidays.include?(end_date)

    errors.add(:base, "Start date and end date cannot be on a holiday")
  end

  def dates_changed?
    saved_change_to_start_date? || saved_change_to_end_date?
  end

  def clear_monthly_goals_cache
    Rails.cache.delete("monthly_goals_#{Date.today.beginning_of_month}")
  end
end
