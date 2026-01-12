class Hub < ApplicationRecord
  validates :name, presence: true
  validates :country, presence: true

  belongs_to :regional_manager, class_name: 'User', optional: true
  has_many :users_hubs
  has_many :users, through: :users_hubs
  has_many :weekly_meetings, dependent: :destroy
  has_many :consent_activities, dependent: :nullify
  has_many :consent_study_hubs, dependent: :destroy
  has_one :booking_config, class_name: 'HubBookingConfig', dependent: :destroy
  has_many :hub_visits, dependent: :destroy

  accepts_nested_attributes_for :booking_config

  after_create :initialize_booking_config

  # Scopes for common queries
  scope :with_main_users, -> { joins(:users_hubs).where(users_hubs: { main: true }) }

  # Get active learners for this hub
  def active_learners
    LearnerInfo.active
               .where(
                 "(learner_infos.hub_id = :hub_id) OR " \
                 "(learner_infos.hub_id IS NULL AND EXISTS " \
                 "(SELECT 1 FROM users_hubs uh WHERE uh.user_id = learner_infos.user_id " \
                 "AND uh.hub_id = :hub_id AND uh.main = TRUE))",
                 hub_id: id
               )
  end

  # Get all learners (excluding certain statuses)
  def learners_excluding_statuses(excluded_statuses)
    LearnerInfo.where.not(status: excluded_statuses)
               .where(
                 "(learner_infos.hub_id = :hub_id) OR (learner_infos.hub_id IS NULL AND EXISTS (SELECT 1 FROM users_hubs uh WHERE uh.user_id = learner_infos.user_id AND uh.hub_id = :hub_id AND uh.main = TRUE))",
                 hub_id: id
               )
  end

  # Get learning coaches for this hub
  def learning_coaches
    users.where(role: 'lc', deactivate: [false, nil])
  end

  # Get learning coaches with fewer than max_hubs hubs
  def learning_coaches_with_capacity(max_hubs = 3)
    learning_coaches
      .left_joins(:hubs)
      .select('users.*, COUNT(hubs.id) AS hubs_count')
      .group('users.id')
      .having('COUNT(hubs.id) < ?', max_hubs)
  end

  # Count of learning coaches in this hub
  def learning_coaches_count
    User.joins(:users_hubs)
        .where(users_hubs: { hub_id: id })
        .where(role: 'lc', deactivate: false)
        .distinct
        .count
  end

  def active_learners_count
    active_learners.count
  end

  def pending_incoming_transfers_count
    ServiceRequest.where(type: 'HubTransferRequest', status: 'pending', target_hub_id: id).count
  end

  def total_occupied_spots
    active_learners_count + pending_incoming_transfers_count
  end

  def free_spots
    return nil unless capacity.present? && capacity.positive?
    [capacity - total_occupied_spots, 0].max
  end

  def capacity_percentage
    return nil unless capacity.present? && capacity.positive?
    ((total_occupied_spots.to_f / capacity.to_f) * 100).round(1)
  end

  def capacity_info
    if capacity.present? && capacity.positive?
      occupied = total_occupied_spots
      free = [capacity - occupied, 0].max
      {
        total: capacity,
        used: occupied,
        free: free,
        percentage: ((occupied.to_f / capacity.to_f) * 100).round(1)
      }
    else
      { total: nil, used: active_learners_count, free: nil, percentage: nil }
    end
  end

  def settings
    booking_config || build_booking_config
  end

  def all_cc_emails
    emails = []
    emails << hub_email if hub_email.present?
    emails.concat(school_contact_emails) if school_contact_emails.any?
    emails.uniq
  end

  private

  def initialize_booking_config
    return if booking_config.present?

    all_slots = []
    current = Time.zone.parse("10:00")
    limit = Time.zone.parse("16:00")

    while current <= limit
      all_slots << current.strftime("%H:%M")
      current += 30.minutes
    end

    default_visit_slots = (1..5).each_with_object({}) do |wday, hash|
      hash[wday.to_s] = all_slots
    end

    create_booking_config(visit_slots: default_visit_slots)
  end
end
