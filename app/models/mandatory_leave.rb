class MandatoryLeave < ApplicationRecord
  has_many :staff_leaves, class_name: 'StaffLeave', dependent: :destroy

  validates :name, :start_date, :end_date, presence: true
  validate :end_after_start

  after_create :distribute_leaves

  private

  def end_after_start
    return if start_date.blank? || end_date.blank?
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def distribute_leaves
    years_range = (start_date.year..end_date.year).to_a
    user_ids_with_entitlement = StaffLeaveEntitlement.where(year: years_range).pluck(:user_id).uniq
    scope = User.where(id: user_ids_with_entitlement).where(deactivate: [false, nil])

    if global
      users = scope
    else
      users = scope.where(role: ['lc', 'cm'])
    end

    users.each do |user|
      sl = StaffLeave.new(
        user: user,
        start_date: start_date,
        end_date: end_date,
        leave_type: 'holiday',
        status: 'approved',
        mandatory_leave: self,
        notes: "Mandatory Leave: #{name}"
      )

      sl.calculate_total_days
      next if sl.total_days == 0

      sl.save(validate: false)
    end
  end
end
