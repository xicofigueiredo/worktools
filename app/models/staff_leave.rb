class StaffLeave < ApplicationRecord
  belongs_to :user
  belongs_to :approver_user, class_name: "User", optional: true

  has_many :confirmations, as: :confirmable, dependent: :destroy
  has_many :staff_leave_documents, dependent: :destroy

  ADVANCE_DAYS = 30
  STATUSES = %w[pending approved rejected cancelled].freeze
  LEAVE_TYPES = ['holiday', 'sick leave', 'paid leave', 'marriage leave', 'parental leave', 'other'].freeze

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
  validate  :paid_leave_minimum_days, on: :create
  validate  :marriage_leave_max_days, on: :create
  validate :notes_required_for_other, on: :create

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
    if ['sick leave', 'paid leave', 'marriage leave', 'parental leave', 'other'].include?(leave_type)
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

  def handle_confirmation_update(confirmation)
    if confirmation.status == 'rejected'
      # For regular confirmations: mark leave rejected
      # For cancellation confirmations: rejection means the cancellation was refused (leave remains as-is)
      update(status: 'rejected') unless confirmation.is_a?(CancellationConfirmation)
    elsif confirmation.status == 'approved'
      if confirmation.is_a?(CancellationConfirmation)
        # Get the list of approvers who have approved the original leave
        approved_confs = confirmations.where(status: 'approved', type: 'Confirmation').order(:updated_at)
        approved_approvers = approved_confs.map(&:approver)
        # Find the index of the current approver in the approved list
        idx = approved_approvers.index(confirmation.approver) || 0

        if idx < (approved_approvers.length - 1)
          # Ask the next manager who approved the original leave to approve the cancellation
          next_approver = approved_approvers[idx + 1]
          confirmations.create!(type: 'CancellationConfirmation', approver: next_approver, status: 'pending')
        else
          # Last approver approved cancellation -> cancel the leave
          update(status: 'cancelled')
        end
      else
        # Normal approval chain for creating approvals
        chain = approval_chain
        next_index = chain.index(confirmation.approver) + 1
        if next_index < chain.length
          confirmations.create!(type: 'Confirmation', approver: chain[next_index], status: 'pending')
        else
          update(status: 'approved')
        end
      end
    end
  end

  def calculate_total_days
    return if start_date.blank? || end_date.blank?
    return if end_date < start_date

    # Other leaves count consecutive calendar days (include weekends & public holidays)
    if ['sick leave', 'paid leave', 'marriage leave', 'parental leave', 'other'].include?(leave_type)
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

  private

  def notes_required_for_other
    if leave_type == 'other' && notes.blank?
      errors.add(:notes, "must explain the purpose of the 'other' leave")
    end
  end

  def marriage_leave_max_days
    return unless leave_type == 'marriage leave'
    return if start_date.blank? || end_date.blank?

    # consecutive days inclusive
    consecutive_days = (end_date - start_date).to_i + 1
    if consecutive_days > 15
      errors.add(:base, "Marriage leave cannot exceed 15 consecutive days")
    end
  end

  def paid_leave_minimum_days
    return unless leave_type == 'paid leave'
    return if start_date.blank? || end_date.blank?

    # consecutive days inclusive
    consecutive_days = (end_date - start_date).to_i + 1
    if consecutive_days < 30
      errors.add(:base, "Paid leave must be at least 30 consecutive days")
    end
  end

  def previous_year_days_allowed
    return unless leave_type == 'holiday' && start_date.present? && end_date.present?

    if days_from_previous_year.present? && days_from_previous_year > 0
      target_year = end_date.year # The year where we want to USE the carry over

      # 1. Basic Window Validation
      jan_apr_start = Date.new(target_year, 1, 1)
      jan_apr_end   = Date.new(target_year, 4, 30)

      slice_start = [start_date, jan_apr_start].max
      slice_end   = [end_date, jan_apr_end].min

      if slice_start > slice_end
        errors.add(:days_from_previous_year, "can only be used for dates overlapping Jan 1 to Apr 30")
        return
      end

      # 2. Check Eligible Days (Business Days in Window)
      temp_leave = StaffLeave.new(user: user, start_date: slice_start, end_date: slice_end, leave_type: leave_type)
      temp_leave.calculate_total_days
      eligible_days = temp_leave.total_days

      if days_from_previous_year > eligible_days
        errors.add(:days_from_previous_year, "cannot exceed the #{eligible_days} working days falling in the Jan-Apr window")
      end

      # 3. Check Real Balance (Entitlement Table)
      # Since 'deduct_entitlement_days' runs after_create, the DB has the 'used' values from all previous requests.

      prev_year = target_year - 1
      ent_prev  = StaffLeaveEntitlement.find_by(user: user, year: prev_year)
      ent_curr  = StaffLeaveEntitlement.find_by(user: user, year: target_year)

      # A. What is physically left in previous year?
      # We must subtract days used by THIS request's 2025 portion (if any)
      days_used_in_prev_year_by_current_request = 0
      if start_date.year == prev_year
        prev_part_leave = StaffLeave.new(user: user, start_date: start_date, end_date: [end_date, Date.new(prev_year, 12, 31)].min, leave_type: 'holiday')
        prev_part_leave.calculate_total_days
        days_used_in_prev_year_by_current_request = prev_part_leave.total_days
      end

      prev_balance = ent_prev ? ent_prev.holidays_left.to_i : 0
      real_prev_balance = [prev_balance - days_used_in_prev_year_by_current_request, 0].max

      # B. Capacity Check (Max 5 total across all requests)
      used_already = ent_curr ? ent_curr.days_from_previous_year_used.to_i : 0
      capacity = [5 - used_already, 0].max

      available = [capacity, real_prev_balance].min

      if days_from_previous_year > available
        errors.add(:days_from_previous_year, "cannot exceed available carry-over balance (#{available}).")
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

  def user_has_days_left
    return if user.blank? || leave_type.blank? || total_days.blank? || start_date.blank?

    years = (start_date.year..end_date.year).to_a
    default_ent = leave_type == 'holiday' ? 25 : 5
    field = leave_type == 'holiday' ? 'holidays_left' : 'sick_leaves_left'

    years.each do |yr|
      # Calculate days needed in this specific year
      y_start = [start_date, Date.new(yr, 1, 1)].max
      y_end   = [end_date, Date.new(yr, 12, 31)].min
      next if y_start > y_end

      temp_leave = StaffLeave.new(user: user, start_date: y_start, end_date: y_end, leave_type: leave_type)
      temp_leave.calculate_total_days
      days_needed = temp_leave.total_days

      next if days_needed == 0

      ent = StaffLeaveEntitlement.find_or_initialize_by(user: user, year: yr)
      available = ent.persisted? ? ent.send(field).to_i : default_ent

      # If this is the Carry-Target Year (e.g. 2026), subtract the specified carry-over
      # from the "Needed" amount, because that amount is covered by 2025's bucket.
      if leave_type == 'holiday' && days_from_previous_year.to_i > 0 && yr == end_date.year
        # We only subtract what we can. If needed=4 and carry=3, needed becomes 1.
        days_needed = [days_needed - days_from_previous_year.to_i, 0].max
      end

      if days_needed > available && !exception_requested
        errors.add(:base, "Not enough days in #{yr}. Needed: #{days_needed}, Available: #{available}.")
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

    existing = user.staff_leaves.where(status: ['pending', 'approved'])
                              .where.not(id: id)
                              .where.not("end_date < ? OR start_date > ?", start_date, end_date)
    if existing.exists?
      existing.each do |leave|
        errors.add(:base, "You already have a pending or approved #{leave.leave_type} in this period from #{leave.start_date} to #{leave.end_date}.")
      end
    end
  end

  def deduct_entitlement_days
    return if total_days.blank? || leave_type.blank? || user.blank?

    years = (start_date.year..end_date.year).to_a

    years.each do |yr|
      # Calculate days strictly for this year part
      y_start = [start_date, Date.new(yr, 1, 1)].max
      y_end   = [end_date, Date.new(yr, 12, 31)].min

      # Helper calculation for days in this specific year
      temp_l = StaffLeave.new(user: user, start_date: y_start, end_date: y_end, leave_type: leave_type)
      temp_l.calculate_total_days
      days_this_year = temp_l.total_days

      next if days_this_year == 0

      entitlement = StaffLeaveEntitlement.find_or_create_by!(user: user, year: yr)

      if leave_type == 'holiday'
        to_deduct = days_this_year

        # CARRY OVER LOGIC
        # We apply carry-over ONLY to the "End Year" (Target Year) of the request.
        # This handles both split-year (Dec-Jan) and same-year (Jan-Jan) requests.
        if days_from_previous_year.to_i > 0 && yr == end_date.year

          prev_year = yr - 1
          prev_ent = StaffLeaveEntitlement.find_or_create_by!(user: user, year: prev_year)

          # Calculate how much we can actually carry for this specific year-chunk
          # (Usually days_from_previous_year, but capped by days_this_year in case of weird splits)
          amount_to_carry = [days_from_previous_year.to_i, days_this_year].min

          # Double check safety (though validation should catch this):
          # Don't take more than what is left in prev year
          amount_to_carry = [amount_to_carry, prev_ent.holidays_left.to_i].min

          if amount_to_carry > 0
            # 1. Remove from Previous Year Balance
            prev_ent.update!(holidays_left: prev_ent.holidays_left.to_i - amount_to_carry)

            # 2. Mark as Used in Current Year
            entitlement.update!(days_from_previous_year_used: entitlement.days_from_previous_year_used.to_i + amount_to_carry)

            # 3. Reduce the deduction from Current Year Balance
            to_deduct -= amount_to_carry
          end
        end

        # Deduct remaining days from this year's balance
        new_left = [entitlement.holidays_left.to_i - to_deduct, 0].max
        entitlement.update!(holidays_left: new_left)

      else
        # Sick/Other Logic
        entitlement.update!(sick_leaves_used: entitlement.sick_leaves_used.to_i + days_this_year)
      end
    end
  end

  def return_entitlement_days
    return if total_days.blank? || leave_type.blank? || user.blank?

    years = (start_date.year..end_date.year).to_a

    years.each do |yr|
      y_start = [start_date, Date.new(yr, 1, 1)].max
      y_end   = [end_date, Date.new(yr, 12, 31)].min

      temp_l = StaffLeave.new(user: user, start_date: y_start, end_date: y_end, leave_type: leave_type)
      temp_l.calculate_total_days
      days_this_year = temp_l.total_days

      next if days_this_year == 0

      entitlement = StaffLeaveEntitlement.find_or_create_by!(user: user, year: yr)

      if leave_type == 'holiday'
        to_return = days_this_year

        # Revert Carry Over if applicable
        if days_from_previous_year.to_i > 0 && yr == end_date.year
          prev_year = yr - 1
          prev_ent = StaffLeaveEntitlement.find_or_create_by!(user: user, year: prev_year)

          # Determine how much was carried
          # We look at what was used, but we must cap by what this leave actually cost
          amount_carried = [days_from_previous_year.to_i, days_this_year].min

          # Cap by what is recorded as used (sanity check)
          amount_carried = [amount_carried, entitlement.days_from_previous_year_used.to_i].min

          if amount_carried > 0
            # 1. Give back to Previous Year
            prev_ent.update!(holidays_left: prev_ent.holidays_left.to_i + amount_carried)

            # 2. Un-mark usage
            entitlement.update!(days_from_previous_year_used: entitlement.days_from_previous_year_used.to_i - amount_carried)

            # 3. Reduce amount to return to Current Year
            to_return -= amount_carried
          end
        end

        entitlement.update!(holidays_left: entitlement.holidays_left.to_i + to_return)
      else
        entitlement.update!(sick_leaves_used: [entitlement.sick_leaves_used.to_i - days_this_year, 0].max)
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
