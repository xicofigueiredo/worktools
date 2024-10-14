class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :holidays, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :weekly_goals, dependent: :destroy
  has_many :sprint_goals, dependent: :destroy
  has_many :users_hubs, dependent: :destroy
  has_many :hubs, through: :users_hubs, dependent: :destroy
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
  enum role: { admin: 'Admin', lc: 'Learning Coach', learner: 'Learner', dc: 'Development Coach', guardian: 'Parent' }
  validate :email_domain_check, on: :create

  after_create :associate_with_hubs, :create_learner_flag
  # after_commit :send_welcome_email, on: :create
  # after_commit :post_create_actions, on: :create


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def subjects_without_timeline
    Subject.left_outer_joins(:timelines).where(timelines: { user_id: nil })
  end

  def timelines_sorted_by_balance
    timelines.order(balance: :asc, start_date: :asc)
  end


  private

  def associate_with_hubs
    if self.role != 'Parent'
      self.hub_ids.each do |hub_id|
        UsersHub.create(user: self, hub_id: hub_id) unless hub_id.blank?
      end
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def create_learner_flag
    #FIXME adjust to create only for learners later
    if self.role == 'Parent'
      build_learner_flag.save
    end
  end

  def email_domain_check
    unless email.ends_with?('@edubga.com')
      errors.add(:email, :invalid_domain)
    end
  end

end
