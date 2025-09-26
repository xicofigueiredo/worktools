class StaffLeave < ApplicationRecord
  belongs_to :user
  belongs_to :approver_user, class_name: "User", optional: true

  has_many :confirmations, dependent: :destroy
  has_many :staff_leave_documents, dependent: :destroy

  ADVANCE_DAYS = 20
  STATUSES = %w[pending approved rejected cancelled].freeze
  LEAVE_TYPES = ['holiday', 'sick leave'].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :leave_type, presence: true, inclusion: { in: LEAVE_TYPES }
  validates :start_date, :end_date, presence: true
  validate  :end_on_or_after_start
  validate  :advance_days_rule, on: :create, if: -> { leave_type == 'holiday' }
  validate  :user_has_days_left, on: :create, if: -> { leave_type == 'holiday' }
  validate  :no_overlapping_blocked_periods, on: :create, if: -> { leave_type == 'holiday' }
  validate  :no_department_overlaps, on: :create, if: -> { leave_type == 'holiday' }
  validate  :no_self_overlaps, on: :create
  validate  :exception_reason_if_requested
  validates :days_from_previous_year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate  :previous_year_days_allowed, on: :create

  before_validation :calculate_total_days, on: [:create, :update]
  after_create :deduct_entitlement_days
  after_create :create_initial_confirmation
  after_update :return_entitlement_days, if: -> { saved_change_to_status? && ['rejected', 'cancelled'].include?(status) && !['rejected', 'cancelled'].include?(saved_changes[:status].first) }

  def compute_total_days
    calculate_total_days
  end

  def approval_chain
    approvers = []
    current_dept = user.departments.first # Assume primary department; adjust if multiple
    while current_dept
      if current_dept.manager && current_dept.manager != user
        approvers << current_dept.manager
      end
      current_dept = current_dept.superior
    end
    approvers
  end

  def exception_user_messages
    (parsed_exception_errors || {})['user'] || []
  end

  def exception_approver_messages
    (parsed_exception_errors || {})['approver'] || exception_user_messages
  end

  def days_in_year(target_year)
    return 0 if start_date.blank? || end_date.blank?
    year_start = [start_date.beginning_of_year, start_date].max
    year_end = [end_date.end_of_year, end_date].min
    return 0 if year_start > year_end

    # Sick leave: consecutive days count (don't skip weekends/holidays)
    if leave_type == 'sick leave'
      count = 0
      (year_start..year_end).each do |d|
        next unless d.year == target_year
        count += 1
      end
      return count
    end

    # Holidays: business days excluding public holidays
    hub = user.users_hubs.find_by(main: true)&.hub
    holiday_dates = PublicHoliday.dates_for_range(hub: hub, start_date: year_start, end_date: year_end).to_set

    count = 0
    (year_start..year_end).each do |d|
      next if d.saturday? || d.sunday?
      next if d.year != target_year
      next if holiday_dates.include?(d)
      count += 1
    end
    count
  end

  private

  def previous_year_days_allowed
    return unless leave_type == 'holiday' && start_date.present? && end_date.present?

    if days_from_previous_year.present? && days_from_previous_year > 0
      target_year = [start_date.year, end_date.year].max
      if Date.current.year < target_year  # Future year request
        jan_mar_start = Date.new(target_year, 1, 1)
        jan_mar_end = Date.new(target_year, 3, 31)
        slice_start = [start_date, jan_mar_start].max
        slice_end = [end_date, jan_mar_end].min
        if slice_start > slice_end
          errors.add(:days_from_previous_year, "can only be used for holidays overlapping Jan 1 to Mar 31 of #{target_year}")
          return
        end

        # Business days in eligible overlap
        temp_leave = StaffLeave.new(user: user, start_date: slice_start, end_date: slice_end, leave_type: leave_type)
        temp_leave.compute_total_days
        eligible_days = temp_leave.total_days

        if days_from_previous_year > eligible_days
          errors.add(:days_from_previous_year, "cannot exceed eligible days in #{target_year} Jan-Mar (#{eligible_days})")
        end

        ent = StaffLeaveEntitlement.find_or_initialize_by(user: user, year: target_year)
        days_from_previous_used = ent.persisted? ? ent.days_from_previous_year_used.to_i : 0
        prev_year = target_year - 1
        prev_ent = StaffLeaveEntitlement.find_by(user: user, year: prev_year)
        prev_available = prev_ent ? [[5 - days_from_previous_used, prev_ent.holidays_left.to_i].min, 0].max : 0

        if days_from_previous_year > prev_available
          errors.add(:days_from_previous_year, "cannot exceed available carry-over days from #{prev_year} (#{prev_available})")
        end
      else
        errors.add(:days_from_previous_year, "carry-over only available for future year requests from current year")
      end
    end
  end

  def end_on_or_after_start
    return if start_date.blank? || end_date.blank?
    if end_date < start_date
      errors.add(:end_date, "must be the same day or after the start date")
    end
  end

  def advance_days_rule
    return if start_date.blank? || leave_type != 'holiday'
    days_until_start = (start_date - Date.current).to_i
    if days_until_start < ADVANCE_DAYS && !exception_requested
      errors.add(:start_date, "must be at least #{ADVANCE_DAYS} days from today (or request an exception)")
    end
  end

  def exception_reason_if_requested
    if exception_requested && exception_reason.blank?
      errors.add(:exception_reason, "must be provided when requesting an exception")
    end
  end

  def calculate_total_days
    return if start_date.blank? || end_date.blank?
    return if end_date < start_date

    # Sick leaves count consecutive calendar days (include weekends & public holidays)
    if leave_type == 'sick leave'
      self.total_days = (end_date - start_date).to_i + 1
      return
    end

    # Holidays: business-day logic (Mon-Fri) excluding public holidays
    hub = user.users_hubs.find_by(main: true)&.hub
    holiday_dates = PublicHoliday.dates_for_range(hub: hub, start_date: start_date, end_date: end_date).to_set

    count = 0
    (start_date..end_date).each do |d|
      next if d.saturday? || d.sunday?
      next if holiday_dates.include?(d)
      count += 1
    end

    self.total_days = count
  end

  def user_has_days_left
    return if user.blank? || leave_type.blank? || total_days.blank? || start_date.blank?

    years = [start_date.year]
    years << end_date.year if end_date.year != start_date.year
    default = leave_type == 'holiday' ? 25 : 5
    field = leave_type == 'holiday' ? 'holidays_left' : 'sick_leaves_left'

    years.each do |yr|
      days_this_year = days_in_year(yr)
      next if days_this_year == 0

      entitlement = StaffLeaveEntitlement.find_or_initialize_by(user: user, year: yr)
      available_current = entitlement.persisted? ? entitlement.send(field).to_i : default

      carry_available = 0
      if leave_type == 'holiday' && yr > Date.current.year && days_this_year > 0
        jan_mar_start = Date.new(yr, 1, 1)
        jan_mar_end = Date.new(yr, 3, 31)
        slice_start = [start_date, jan_mar_start].max
        slice_end = [end_date, jan_mar_end].min
        if slice_start <= slice_end
          temp_leave = StaffLeave.new(user: user, start_date: slice_start, end_date: slice_end, leave_type: leave_type)
          temp_leave.compute_total_days
          eligible_carry = temp_leave.total_days
          prev_ent = StaffLeaveEntitlement.find_by(user: user, year: yr - 1)
          days_used = entitlement.persisted? ? entitlement.days_from_previous_year_used.to_i : 0
          carry_available = prev_ent ? [[5 - days_used, prev_ent.holidays_left.to_i].min, eligible_carry].min : 0
        end
      end

      needed = days_this_year
      needed -= days_from_previous_year.to_i if yr == end_date.year  # Apply carry to next year
      total_available = available_current + carry_available

      if needed > total_available && !exception_requested
        over = needed - total_available
        errors.add(:base, "Exceeded #{leave_type} days in #{yr} by #{over}. Request an exception.")
      end
    end
  end

  def no_overlapping_blocked_periods
    return if start_date.blank? || end_date.blank? || user.blank?

    hub_id = user.users_hubs.find_by(main: true)&.hub_id
    department_ids = user.department_ids
    user_type = user.role # Adjusted to role as per note

    blocked = BlockedPeriod.where("(user_id = :user_id OR user_type = :user_type OR hub_id = :hub_id OR department_id IN (:department_ids)) AND start_date <= :end_date AND end_date >= :start_date",
                                  user_id: user.id, user_type: user_type, hub_id: hub_id, department_ids: department_ids,
                                  start_date: start_date, end_date: end_date)

    if blocked.exists? && !exception_requested
      errors.add(:base, "Overlaps with blocked periods. Request an exception to proceed.")
    end
  end

  def no_department_overlaps
    return if exception_requested || user.departments.blank?

    overlapping = false
    user.departments.each do |dept|
      dept_user_ids = dept.user_ids - [user.id]
      if StaffLeave.where(user_id: dept_user_ids, status: ['pending', 'approved'], leave_type: leave_type)
                   .where.not("end_date < ? OR start_date > ?", start_date, end_date).exists?
        overlapping = true
        break
      end
    end

    if overlapping
      errors.add(:base, "Department members have holidays in this period. Request an exception to proceed.")
    end
  end

  def no_self_overlaps
    return if start_date.blank? || end_date.blank? || user.blank?

    if user.staff_leaves.where(status: ['pending', 'approved'], leave_type: leave_type)
                        .where.not("end_date < ? OR start_date > ?", start_date, end_date).exists?
      errors.add(:base, "You already have a pending or approved #{leave_type} in this period.")
    end
  end

  def deduct_entitlement_days
    return if total_days.blank? || leave_type.blank? || user.blank?

    years = [start_date.year]
    years << end_date.year if end_date.year != start_date.year

    years.each do |yr|
      days_this_year = days_in_year(yr)
      next if days_this_year == 0

      entitlement = StaffLeaveEntitlement.find_or_create_by!(user: user, year: yr)

      if leave_type == 'holiday'
        field = :holidays_left
        to_deduct = days_this_year

        # For next year holiday, apply carry-over first if selected
        if yr > start_date.year && days_from_previous_year.to_i > 0
          prev_year = yr - 1
          prev_ent = StaffLeaveEntitlement.find_or_create_by!(user: user, year: prev_year)
          actually_carry = [days_from_previous_year.to_i, days_this_year, 5 - entitlement.days_from_previous_year_used.to_i, prev_ent.holidays_left.to_i].min

          if actually_carry > 0
            prev_ent.update!(holidays_left: [prev_ent.holidays_left.to_i - actually_carry, 0].max)
            entitlement.update!(days_from_previous_year_used: entitlement.days_from_previous_year_used.to_i + actually_carry)
            to_deduct -= actually_carry
          end
        end

        # Deduct remainder from this year's entitlement
        new_left = [entitlement.send(field).to_i - to_deduct, 0].max
        entitlement.update!(field => new_left)
      else
        # sick leave: increment sick_leaves_used (no hard caps / verification)
        to_add = days_this_year
        entitlement.update!(sick_leaves_used: entitlement.sick_leaves_used.to_i + to_add)
      end
    end
  end

  def return_entitlement_days
    return if total_days.blank? || leave_type.blank? || user.blank?

    years = [start_date.year]
    years << end_date.year if end_date.year != start_date.year

    years.each do |yr|
      days_this_year = days_in_year(yr)
      next if days_this_year == 0

      entitlement = StaffLeaveEntitlement.find_or_create_by!(user: user, year: yr)

      if leave_type == 'holiday'
        field = :holidays_left
        to_return = days_this_year

        # For next year holiday, return carry-over first if used
        if yr > start_date.year && days_from_previous_year.to_i > 0
          prev_year = yr - 1
          prev_ent = StaffLeaveEntitlement.find_or_create_by!(user: user, year: prev_year)
          actually_carry = [days_from_previous_year.to_i, days_this_year, entitlement.days_from_previous_year_used.to_i].min

          if actually_carry > 0
            prev_ent.update!(holidays_left: prev_ent.holidays_left.to_i + actually_carry)
            entitlement.update!(days_from_previous_year_used: [entitlement.days_from_previous_year_used.to_i - actually_carry, 0].max)
            to_return -= actually_carry
          end
        end

        # Return remainder to this year's entitlement
        entitlement.update!(field => entitlement.send(field).to_i + to_return)
      else
        # sick leave: subtract from sick_leaves_used (but never go below zero)
        to_return = days_this_year
        new_used = [entitlement.sick_leaves_used.to_i - to_return, 0].max
        entitlement.update!(sick_leaves_used: new_used)
      end
    end
  end

  def create_initial_confirmation
    chain = approval_chain
    if chain.present?
      confirmations.create!(type: 'Confirmation', approver: chain.first, status: 'pending')
    else
      update(status: 'approved')
    end
  end

  # --- Exception errors parsing helpers (persisted as JSON { user: [...], approver: [...] })
  # Return a Hash { "user" => [...], "approver" => [...] } or nil
  def parsed_exception_errors
    return nil if exception_errors.blank?

    # Attempt JSON parse
    begin
      parsed = JSON.parse(exception_errors)
      if parsed.is_a?(Hash) && (parsed['user'].is_a?(Array) || parsed['approver'].is_a?(Array))
        return parsed
      end
    rescue JSON::ParserError
      # Fall through to legacy handling
    end

    # Legacy fallback: store the whole value in both user and approver arrays
    { 'user' => [exception_errors.to_s], 'approver' => [exception_errors.to_s] }
  end
end
