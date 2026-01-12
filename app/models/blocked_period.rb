class BlockedPeriod < ApplicationRecord
  belongs_to :hub, optional: true
  belongs_to :department, optional: true
  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User', optional: true

  validate :end_date_after_start_date

  # Scope for calendar filtering
  def self.for_calendar_view(start_date:, end_date:, hub_id: nil, department_id: nil)
    # 1. Overlap Check
    query = where("start_date <= ? AND end_date >= ?", end_date, start_date)

    # 2. Context Filtering (Hub vs Dept vs Global)
    if hub_id.present?
      # Specific Hub OR Global (all context fields nil)
      query = query.where("hub_id = ? OR (hub_id IS NULL AND department_id IS NULL AND user_id IS NULL)", hub_id)
    elsif department_id.present?
      # Specific Dept OR Global
      query = query.where("department_id = ? OR (hub_id IS NULL AND department_id IS NULL AND user_id IS NULL)", department_id)
    end

    query
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after or equal to the start date")
    end
  end
end
