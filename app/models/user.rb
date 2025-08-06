class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :holidays, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :moodle_timelines, dependent: :destroy
  has_many :weekly_goals, dependent: :destroy
  has_many :sprint_goals, dependent: :destroy
  has_many :users_hubs, dependent: :destroy
  has_many :hubs, through: :users_hubs, dependent: :destroy

  # Define an association to fetch the join record that is marked as main.
  has_one :main_users_hub, -> { where(main: true) }, class_name: 'UsersHub'
  # Define an association to get the actual hub that is the main hub.
  has_one :main_hub, through: :main_users_hub, source: :hub

  has_many :user_topics, dependent: :destroy
  has_many :topics, through: :user_topics, dependent: :destroy
  attr_accessor :weekly_goal_completed

  has_many :kdas, dependent: :destroy
  # has_many :weekly_meetings, dependent: :destroy
  # has_many :monday_slots_as_lc, class_name: 'MondaySlot', foreign_key: 'lc_id', dependent: :destroy
  # has_many :tuesday_slots_as_lc, class_name: 'TuesdaySlot', foreign_key: 'lc_id', dependent: :destroy
  # has_many :wednesday_slots_as_lc, class_name: 'WednesdaySlot', foreign_key: 'lc_id', dependent: :destroy
  # has_many :thursday_slots_as_lc, class_name: 'ThursdaySlot', foreign_key: 'lc_id', dependent: :destroy
  # has_many :friday_slots_as_lc, class_name: 'FridaySlot', foreign_key: 'lc_id', dependent: :destroy
  # has_many :monday_slots_as_learner, class_name: 'MondaySlot', foreign_key: 'learner_id', dependent: :destroy
  # has_many :tuesday_slots_as_learner, class_name: 'TuesdaySlot', foreign_key: 'learner_id', dependent: :destroy
  # has_many :wednesday_slots_as_learner, class_name: 'WednesdaySlot', foreign_key: 'learner_id', dependent: :destroy
  # has_many :thursday_slots_as_learner, class_name: 'ThursdaySlot', foreign_key: 'learner_id', dependent: :destroy
  # has_many :friday_slots_as_learner, class_name: 'FridaySlot', foreign_key: 'learner_id', dependent: :destroy
  has_many :lws_timelines, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_one :learner_flag, dependent: :destroy
  has_many :reports
  has_many :notifications, dependent: :destroy
  has_many :chats, dependent: :destroy

  enum role: { admin: 'Admin', lc: 'Learning Coach', learner: 'Learner', rm: 'Regional Manager', guardian: 'Parent', cm: 'Course Manager', exams: 'Exams', edu: 'Edu' }
  validate :email_domain_check, on: :create

  before_save :ensure_deactivated_if_graduated

  after_create :associate_with_hubs, :create_learner_flag
  # after_commit :send_welcome_email, on: :create
  # after_commit :post_create_actions, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  scope :with_country, ->(country) {
    joins(userhubs: :hub).where(hubs: { country: country })
  }

  scope :with_role, ->(role) {
    where(role: role)
  }

  scope :with_level, ->(level) {
    joins(:timelines).where(timelines: { hidden: false, subject: level })
  }

  def subjects_without_timeline
    Subject.left_outer_joins(:timelines).where(timelines: { user_id: nil })
  end

  def timelines_sorted_by_balance
    timelines.order(balance: :asc, start_date: :asc)
  end

  def moodle_timelines_sorted_by_balance
    moodle_timelines.order(balance: :asc, start_date: :asc)
  end

  def subject_records
    Subject.where(id: subjects)
  end

  private

  def associate_with_hubs
    return unless role != 'Parent'

    hub_ids.each do |hub_id|
      UsersHub.create(user: self, hub_id:) unless hub_id.blank?
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def create_learner_flag
    # FIXME: adjust to create only for learners later
    return if role != 'Learner'

    build_learner_flag.save
  end

  def email_domain_check
    valid_domains = ['@edubga.com', '@bravegenerationacademy.com']
    return if valid_domains.any? { |domain| email.ends_with?(domain) }

    errors.add(:email, :invalid_domain, message: 'Email must be from @edubga.com or @bravegenerationacademy.com')
  end

  def can_access_learner?(learner)
    self == learner || (self.role.in?(['Admin', 'Learning Coach']) && (self.hubs & learner.hubs).present?)
  end

  def ensure_deactivated_if_graduated
    if attribute_present?("graduated_at") && !deactivate
      self.deactivate = true
    end
  end

end
