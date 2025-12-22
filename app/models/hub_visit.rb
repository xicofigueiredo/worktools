class HubVisit < ApplicationRecord
  belongs_to :hub

  enum status: { pending: 'pending', confirmed: 'confirmed', cancelled: 'cancelled', rejected: 'rejected' }
  enum visit_type: { visit: 'visit', trial: 'trial' }

  validates :first_name, :last_name, :email, :start_time, :end_time, :learner_name, :learner_academic_level, presence: true
  validates :learner_age, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :check_availability, on: :create

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def check_availability
    return unless start_time && end_time && hub

    # 1. Check overlaps with other confirmed visits
    overlaps = HubVisit.where(hub_id: hub_id)
                       .where.not(status: ['cancelled', 'rejected'])
                       .where("start_time < ? AND end_time > ?", end_time, start_time)
                       .exists?

    if overlaps
      errors.add(:base, "This time slot is no longer available.")
    end

    # 2. Check Blocked Periods (LCs/HR blocks)
    blocked = BlockedPeriod.where(hub_id: hub_id)
                           .where("start_date <= ? AND end_date >= ?", start_time.to_date, start_time.to_date)
                           .exists?

    if blocked
      errors.add(:base, "The Hub is blocked for events on this date.")
    end
  end
end
