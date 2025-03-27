class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true

  after_create :create_user_topics
  after_save :clear_monthly_goals_cache, if: :dates_changed?
  before_save :calculate_difference, if: :progress_and_expected_progress_present?

  has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_user_topics
  belongs_to :exam_date, optional: true
  belongs_to :lws_timeline, optional: true
  has_many :user_topics
  has_many :topics, through: :user_topics
  has_many :timeline_progresses, dependent: :destroy
  has_many :weeks, through: :timeline_progresses
  has_many :moodle_topics, dependent: :destroy

  validate :start_date_before_end_date
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_cannot_be_holidays
  validate :end_date_before_expected

  def create_user_topics
    subject.topics.order(:order).find_each do |topic|
      user.user_topics.create!(topic:, done: false)
    end
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
    tp.expected = expected_progress
    tp.difference = difference
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

  def calculate_difference
    if progress.present? && expected_progress.present?
      self.difference = progress - expected_progress
    else
      self.difference = nil
    end
  end

  def end_date_before_expected
    return unless exam_date

    # Skip this validation if only toggling the hidden state
    return if changed_attributes.keys == ['hidden']


    # Map the expected end date based on the exam month
    expected_end_date = case exam_date.date.month
                        when 5, 6 # May/June exams
                          Date.new(exam_date.date.year, 2, 28)
                        when 10, 11 # October/November exams
                          Date.new(exam_date.date.year, 7, 28)
                        when 1 # January exams
                          Date.new(exam_date.date.year - 1, 10, 28) # Previous year for October
                        else
                          nil
                        end

    # Validate if end_date is before or on the expected end date
    if expected_end_date && end_date > expected_end_date
      errors.add(:end_date, "must be on or before #{expected_end_date.strftime('%d %B %Y')} for the selected exam session.")
    end
  end

  private

  def progress_and_expected_progress_present?
    progress.present? && expected_progress.present?
  end
end
