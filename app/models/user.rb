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
  has_many :consents, dependent: :destroy

  has_many :staff_leaves, dependent: :destroy, class_name: "StaffLeave"
  has_many :staff_leave_entitlements, dependent: :destroy, class_name: "StaffLeaveEntitlement"
  has_many :users_departments, dependent: :destroy
  has_many :departments, through: :users_departments, dependent: :destroy
  has_many :managed_departments, class_name: 'Department', foreign_key: 'manager_id'
  has_many :confirmations, foreign_key: 'approver_id'

  has_one :learner_info, dependent: :destroy
  has_one :collaborator_info, dependent: :destroy
  has_one :csc_diploma, dependent: :destroy
  delegate :can_teach_pt_plus, :can_teach_pt_plus?,
           :can_teach_remote, :can_teach_remote?,
           to: :collaborator_info, allow_nil: true

  enum role: {
    admin: 'Admin',
    lc: 'Learning Coach',
    learner: 'Learner',
    rm: 'Regional Manager',
    guardian: 'Parent',
    cm: 'Course Manager',
    exams: 'Exams',
    edu: 'Edu',
    staff: 'Staff',
    admissions: 'Admissions',
    finance: 'Finance',
    ops: 'Operations',
    it: 'IT Support'
  }

  STAFF_ROLES = %i[admin lc rm cm exams edu staff admissions finance ops it]

  validate :email_domain_check, on: :create

  before_save :ensure_deactivated_if_graduated

  after_create :associate_with_hubs, :create_learner_flag
  # after_create :create_collaborator_info_if_needed
  # after_commit :send_welcome_email, on: :create
  # after_commit :post_create_actions, on: :create

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Prevent deactivated users from logging in
  def active_for_authentication?
    super && !deactivate
  end

  # Custom message for deactivated users
  def inactive_message
    deactivate ? :deactivated : super
  end

  scope :with_country, ->(country) {
    joins(userhubs: :hub).where(hubs: { country: country })
  }

  scope :with_role, ->(role) {
    where(role: role)
  }

  scope :with_level, ->(level) {
    joins(:timelines).where(timelines: { hidden: false, subject: level })
  }

  # Scope to find parents whose children are all deactivated
  scope :parents_with_all_deactivated_children, -> {
    where(role: 'guardian')
      .where.not(kids: [])
      .select { |parent| parent.all_children_deactivated? }
  }

  # Scope to find deactivated learners
  scope :deactivated_learners, -> {
    where(role: 'learner', deactivate: true)
  }

  # Scope to find active learners
  scope :active_learners, -> {
    where(role: 'learner', deactivate: false)
  }

  scope :staff, -> { where(role: STAFF_ROLES) }

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

  # Get children (learners) associated with this parent
  def children
    return User.none unless guardian? && kids.present?
    User.where(id: kids)
  end

  # Check if all children are deactivated
  def all_children_deactivated?
    return false unless guardian? && kids.present?
    children.all?(&:deactivate)
  end

  # Check if parent should have access (has at least one active child)
  def parent_has_access?
    return true unless guardian?
    return false if kids.blank?
    !all_children_deactivated?
  end

  # Check if learner should have access (not deactivated)
  def learner_has_access?
    return true unless learner?
    !deactivate
  end

  # Check if user should have access based on their role
  def has_access?
    return parent_has_access? if guardian?
    return learner_has_access? if learner?
    true # Other roles (admin, lc, cm, etc.) always have access unless explicitly restricted
  end

  def staff?
    STAFF_ROLES.include?(role.to_sym)
  end

  def online_learners
    User.joins(:learner_info)
        .merge(LearnerInfo.active)
        .where(learner_infos: { learning_coach_id: id, programme: "Online" })
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
    valid_domains = ['@edubga.com', '@bravegenerationacademy.com', '@brave-future.com']
    return if valid_domains.any? { |domain| email.ends_with?(domain) }

    errors.add(:email, :invalid_domain, message: 'Email must be from @edubga.com or @bravegenerationacademy.com')
  end

  def can_access_learner?(learner)
    self == learner || (self.role.in?(['Admin', 'Learning Coach', 'Regional Manager']) && (self.hubs & learner.hubs).present?)
  end

  def ensure_deactivated_if_graduated
    if attribute_present?("graduated_at") && !deactivate
      self.deactivate = true
    end
  end

  # INTERESSANTE FAZER COM SE O ROLE ESTIVER DENTRO DOS ROLES DE STAFF
  # def create_collaborator_info_if_needed
  #   if role == 'lc'
  #     create_collaborator_info
  #   end
  # end

end
