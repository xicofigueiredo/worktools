class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  after_create :create_user_topics
  has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_user_topics

  validate :start_date_before_end_date
  validates :subject_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true


  enum exam_season: { jan: 'January', may_jun: 'May/June', oct_nov: 'October/November' }

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
end
