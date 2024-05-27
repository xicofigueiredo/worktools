class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true

  after_create :create_user_topics

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
  validate :start_date_cannot_be_equal_to_end_date
  validate :dates_cannot_be_holidays


  def create_user_topics
    self.subject.topics.order(:order).find_each do |topic|
      self.user.user_topics.create!(topic: topic, done: false)
    end
  end

  def calculate_total_time
    self.total_time = (self.end_date - self.start_date)
  end

  def start_date_before_end_date
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def destroy_associated_user_topics
    user.user_topics.joins(:topic).where(topics: { subject_id: subject_id }).destroy_all
  end

  def update_weekly_progress(week)
    tp = timeline_progresses.find_or_initialize_by(week: week)
    tp.progress = self.progress
    tp.save!
  end

  private

  def start_date_cannot_be_equal_to_end_date
    if start_date == end_date
      errors.add(:end_date, "cannot be the same as the start date")
    end
  end

  def dates_cannot_be_holidays
    holidays = self.user.holidays
    if holidays.include?(start_date) || holidays.include?(end_date)
      errors.add(:base, "Start date and end date cannot be on a holiday")
    end
  end
end
