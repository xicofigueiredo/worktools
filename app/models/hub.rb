class Hub < ApplicationRecord
  validates :name, presence: true
  validates :country, presence: true

  belongs_to :regional_manager, class_name: 'User', optional: true
  has_many :users_hubs
  has_many :users, through: :users_hubs
  has_many :weekly_meetings, dependent: :destroy
  has_many :consent_activities, dependent: :nullify
  has_many :consent_study_hubs, dependent: :destroy

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

  # Count of active learners
  def active_learners_count
    active_learners.count
  end

  # Calculate free spots based on capacity
  def free_spots
    return nil unless capacity.present? && capacity.positive?
    [capacity - active_learners_count, 0].max
  end

  # Calculate capacity percentage
  def capacity_percentage
    return nil unless capacity.present? && capacity.positive?
    ((active_learners_count.to_f / capacity.to_f) * 100).round(1)
  end

  # Get capacity info as a hash
  def capacity_info
    if capacity.present? && capacity.positive?
      {
        total: capacity,
        used: active_learners_count,
        free: free_spots,
        percentage: capacity_percentage
      }
    else
      {
        total: nil,
        used: active_learners_count,
        free: nil,
        percentage: nil
      }
    end
  end
end
