class StaffLeaveEntitlement < ApplicationRecord
  belongs_to :user

  validates :annual_holidays, :holidays_left, numericality: { greater_than_or_equal_to: 0 }
  validates :year, presence: true, uniqueness: { scope: :user_id }

  after_create :apply_existing_mandatory_leaves

  # Calculate pro-rated holidays based on start date
  def self.calculate_pro_rated_holidays(start_date, year = Date.current.year, base_amount = 25)
    return base_amount if start_date.blank?

    year_start = Date.new(year, 1, 1)
    year_end = Date.new(year, 12, 31)

    # If they start before or at the beginning of the year, give full amount
    return base_amount if start_date <= year_start

    # If they start after the year ends, give 0
    return 0 if start_date > year_end

    # Calculate pro-rated amount based on remaining days in year
    total_days = (year_end - year_start).to_i + 1
    remaining_days = (year_end - start_date).to_i + 1

    ((remaining_days.to_f / total_days) * base_amount).round
  end

  # Get users without entitlement for a given year in specified departments
  # If department_ids is nil or empty, returns users across all departments.
  def self.users_without_entitlement(department_ids, year)
    base = User.where(role: User.roles[:staff]) # only staff users

    # apply department filter only when department_ids is present
    if department_ids.present?
      base = base.joins(:users_departments)
                .where(users_departments: { department_id: department_ids })
    end

    base.where.not(id: StaffLeaveEntitlement.where(year: year).select(:user_id))
        .distinct
        .order(:full_name)
        .select(:id, :full_name)
  end

  # Create entitlement with validation
  def self.create_for_user(user:, year:, annual_holidays:, holidays_left:, manager:)
    # Check authorization
    is_admin_or_hr = manager.role == 'admin' || manager.email == 'humanresources@bravegenerationacademy.com'

    authorized = is_admin_or_hr || manager.managed_departments.any? do |dept|
      user.departments.any? { |user_dept| dept.subtree_ids.include?(user_dept.id) }
    end

    return { success: false, error: 'Unauthorized', status: :unauthorized } unless authorized

    # Check if already exists
    if exists?(user: user, year: year)
      return { success: false, error: 'Entitlement already exists for this user and year', status: :unprocessable_entity }
    end

    entitlement = new(
      user: user,
      year: year,
      annual_holidays: annual_holidays,
      holidays_left: holidays_left,
      days_from_previous_year: days_from_previous_year
    )

    if entitlement.save
      { success: true, entitlement: entitlement }
    else
      { success: false, error: entitlement.errors.full_messages.to_sentence, status: :unprocessable_entity }
    end
  end

  # Update entitlement with validation
  def update_for_manager(annual_holidays:, holidays_left:, days_from_previous_year:, manager:)
    # Check authorization
    is_admin_or_hr = manager.role == 'admin' || manager.email == 'humanresources@bravegenerationacademy.com'

    authorized = is_admin_or_hr || manager.managed_departments.any? do |dept|
      user.departments.any? { |user_dept| dept.subtree_ids.include?(user_dept.id) }
    end

    return { success: false, error: 'Unauthorized', status: :unauthorized } unless authorized

    if update(annual_holidays: annual_holidays, holidays_left: holidays_left, days_from_previous_year: days_from_previous_year)
      { success: true, entitlement: self }
    else
      { success: false, error: errors.full_messages.to_sentence, status: :unprocessable_entity }
    end
  end

  private

  def apply_existing_mandatory_leaves
    mandatory_leaves = MandatoryLeave.where("extract(year from start_date) = ? OR extract(year from end_date) = ?", year, year)

    mandatory_leaves.each do |ml|
      # Check if this user qualifies (Global or Role)
      should_apply = ml.global || (user.role.in?(['lc', 'cm']))

      if should_apply
        unless StaffLeave.exists?(user: user, mandatory_leave: ml)
          sl = StaffLeave.new(
            user: user,
            start_date: ml.start_date,
            end_date: ml.end_date,
            leave_type: 'holiday',
            status: 'approved',
            mandatory_leave: ml,
            notes: "Mandatory Leave: #{ml.name}"
          )

          sl.calculate_total_days
          next if sl.total_days == 0

          sl.save(validate: false)
        end
      end
    end
  end
end
