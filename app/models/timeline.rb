class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  after_create :create_user_topics
  after_create :assign_mock_deadlines
  after_update :assign_mock_deadlines

  has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_user_topics
  belongs_to :exam_date, optional: true
  belongs_to :lws_timeline, optional: true
  has_many :user_topics
  has_many :topics, through: :user_topics
  has_many :timeline_progresses, dependent: :destroy
  has_many :weeks, through: :timeline_progresses



  validate :start_date_before_end_date
  validates :subject_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def create_user_topics
    self.subject.topics.find_each do |topic|
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

  def assign_mock_deadlines
    # Assign `mock50` value
    mock50_topic = self.subject.topics.find_by(Mock50: true)
    self.mock50 = self.user.user_topics.find_by(topic: mock50_topic)&.deadline if mock50_topic

    # Assign `mock100` value
    mock100_topic = self.subject.topics.find_by(Mock100: true)
    self.mock100 = self.user.user_topics.find_by(topic: mock100_topic)&.deadline if mock100_topic

    self.save!
  end
end
