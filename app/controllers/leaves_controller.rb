class LeavesController < ApplicationController
  before_action :authenticate_user! if respond_to?(:authenticate_user!, true)
  ADVANCE_DAYS = StaffLeave::ADVANCE_DAYS

  def index
    @user_leaves = current_user.staff_leaves.order(created_at: :desc)

    @month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @next_month = @month.next_month
    @prev_month = @month.prev_month

    if current_user.managed_departments.present?
      prepare_manager_entitlements if current_user&.managed_departments&.present?
      @pending_confirmations = current_user.confirmations.pending.includes(:confirmable)

      depts = current_user.managed_departments
      is_top = depts.all? { |d| d.superior.nil? }

      if is_top
        @department_leaves = StaffLeave.where("start_date <= ? AND end_date >= ?", @month.end_of_month, @month).order(start_date: :asc)
      else
        all_users = depts.flat_map do |dept|
          dept.all_users # Assume recursive method in Department
        end.uniq
        @department_leaves = StaffLeave.where(user: all_users).where("start_date <= ? AND end_date >= ?", @month.end_of_month, @month).order(start_date: :asc)
      end
    else
      @pending_confirmations = []
      @department_leaves = []
    end
  end

  def new
    @staff_leave = current_user.staff_leaves.new
  end

  def create
    @staff_leave = current_user.staff_leaves.build(staff_leave_params)
    @staff_leave.exception_requested = ActiveModel::Type::Boolean.new.cast(staff_leave_params[:exception_requested])
    @staff_leave.days_from_previous_year = staff_leave_params[:days_from_previous_year].to_i if staff_leave_params[:days_from_previous_year].present?

    # Enforce mandatory medical document for sick leaves (server-side)
    if ['sick leave', 'marriage leave', 'parental leave'].include?(@staff_leave.leave_type)
      docs_param = params.dig(:staff_leave, :documents)
      # docs_param can be nil, an array, or a file. We consider it missing if nil or only blank strings.
      docs_present = docs_param.present? && docs_param.any? { |d| d.present? && !d.is_a?(String) }
      unless docs_present
        @staff_leave.errors.add(:base, "Document required for #{@staff_leave.leave_type}")
        flash.now[:alert] = @staff_leave.errors.full_messages.to_sentence
        return render :new, status: :unprocessable_entity
      end
    end

    if @staff_leave.save
      # Handle document uploads (only for sick leaves by default)
      # expects params[:staff_leave][:documents] (array of uploaded files)
      if ['sick leave', 'marriage leave', 'parental leave'].include?(@staff_leave.leave_type) && params.dig(:staff_leave, :documents).present?
        upload_errors = []
        params[:staff_leave][:documents].each do |doc|
          next if doc.blank? || doc.is_a?(String)
          begin
            document = @staff_leave.staff_leave_documents.create!(
              file_name: doc.original_filename,
              description: params[:staff_leave][:document_description]
            )
            document.file.attach(doc)

            unless document.valid?
              document.destroy
              upload_errors << "#{doc.original_filename}: #{document.errors.full_messages.join(', ')}"
            end
          rescue => e
            upload_errors << "#{doc.original_filename}: #{e.message}"
          end
        end

        if upload_errors.any?
          flash[:alert] = "Some files could not be uploaded: #{upload_errors.join('; ')}"
        end
      end
      redirect_to leaves_path, notice: "Leave request created: #{@staff_leave.start_date} → #{@staff_leave.end_date} (#{@staff_leave.total_days} days)."
    else
      flash.now[:alert] = @staff_leave.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def delete_document
    @staff_leave = current_user.staff_leaves.find(params[:id])
    document = @staff_leave.staff_leave_documents.find(params[:doc_id])
    document.file.purge if document.file.attached?
    document.destroy
    redirect_back fallback_location: leaves_path, notice: "Document deleted."
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: leaves_path, alert: "Document not found or you don't have permission."
  end

  def download_document
    @staff_leave = StaffLeave.find(params[:id])
    document = @staff_leave.staff_leave_documents.find(params[:doc_id])

    if document.file.attached?
      redirect_to rails_blob_path(document.file, disposition: "attachment")
    else
      redirect_back fallback_location: leaves_path, alert: "File not attached."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: leaves_path, alert: "Document not found."
  end

  def show
    @staff_leave = current_user.staff_leaves.find(params[:id])
  end

  # POST /leaves/preview
  def preview
    begin
      start_date = Date.parse(params[:start_date].to_s)
      end_date   = Date.parse(params[:end_date].to_s)
    rescue ArgumentError
      return render json: { error: "Invalid start_date or end_date" }, status: :unprocessable_entity
    end

    leave_type = params[:leave_type].to_s
    if end_date < start_date
      return render json: { error: "end_date must be the same or after start_date" }, status: :unprocessable_entity
    end

    # build a StaffLeave to compute totals using model logic (which handles sick/paid vs holiday)
    staff_leave = StaffLeave.new(user: current_user, start_date: start_date, end_date: end_date, leave_type: leave_type)
    staff_leave.compute_total_days

    # Build per-year counts and per-year entitlements
    years = (start_date.year..end_date.year).to_a
    days_by_year = {}
    entitlements_by_year = {}

    years.each do |yr|
      # days_in_year uses model logic: consecutive for sick/paid, business days for holiday
      days_by_year[yr] = staff_leave.days_in_year(yr)

      ent = StaffLeaveEntitlement.find_or_initialize_by(user: current_user, year: yr)
      if ent.new_record?
        ent.annual_holidays = 25
        ent.holidays_left = 25
      end

      if leave_type == 'holiday'
        entitlements_by_year[yr] = ent.holidays_left.to_i
      else
        entitlements_by_year[yr] = 0
      end
    end

    # Jan-Mar carry logic only meaningful for holidays; reuse previous logic (no change)
    jan_mar_segments = []
    years.each do |yr|
      jan_mar_start = Date.new(yr, 1, 1)
      jan_mar_end   = Date.new(yr, 3, 31)
      slice_start = [start_date, jan_mar_start].max
      slice_end   = [end_date, jan_mar_end].min
      next if slice_start > slice_end

      temp_leave = StaffLeave.new(user: current_user, start_date: slice_start, end_date: slice_end, leave_type: leave_type)
      temp_leave.compute_total_days
      eligible_carry_days = temp_leave.total_days.to_i

      prev_year = yr - 1
      prev_ent = StaffLeaveEntitlement.find_by(user: current_user, year: prev_year)
      if prev_ent.nil?
        prev_holidays_left = 25
      else
        prev_holidays_left = prev_ent.holidays_left.to_i
      end

      entitlement_for_this_year = StaffLeaveEntitlement.find_or_initialize_by(user: current_user, year: yr)
      if entitlement_for_this_year.new_record?
        entitlement_for_this_year.annual_holidays = 25
        entitlement_for_this_year.holidays_left = 25
      end
      days_from_previous_used = entitlement_for_this_year.days_from_previous_year_used.to_i

      previous_year_carry = [[5 - days_from_previous_used, prev_holidays_left].min, eligible_carry_days].min
      previous_year_carry = [previous_year_carry, 0].max

      jan_mar_segments << {
        year: yr,
        eligible_carry_days: eligible_carry_days,
        previous_year: prev_year,
        previous_year_holidays_left: prev_holidays_left,
        previous_year_carry: previous_year_carry,
        days_from_previous_year_used: days_from_previous_used
      }
    end

    # blocked periods & overlaps adjustments:
    blocked = false
    blocked_messages = []
    if leave_type == 'holiday'
      hub_id = current_user.users_hubs.find_by(main: true)&.hub_id
      department_ids = current_user.department_ids
      user_type = current_user.role

      blocked_periods = BlockedPeriod.where("(user_id = :user_id OR user_type = :user_type OR hub_id = :hub_id OR department_id IN (:department_ids)) AND start_date <= :end_date AND end_date >= :start_date",
                                            user_id: current_user.id, user_type: user_type, hub_id: hub_id, department_ids: department_ids,
                                            start_date: start_date, end_date: end_date)
      blocked = blocked_periods.exists?
      blocked_messages = blocked_periods.map do |bp|
        scope = if bp.user_id
                  "your account"
                elsif bp.user_type
                  "user type #{bp.user_type}"
                elsif bp.hub_id
                  "hub #{Hub.find(bp.hub_id).name}"
                elsif bp.department_id
                  "department #{Department.find(bp.department_id).name}"
                else
                  "unknown scope"
                end
        "Can't take holidays on blocked period from #{bp.start_date} to #{bp.end_date} for #{scope}."
      end
    end

    # overlaps (only for holidays)
    overlapping_messages = []
    if leave_type == 'holiday'
      if current_user.role == 'lc'
        main_hub = current_user.users_hubs.find_by(main: true)&.hub
        hub_lc_user_ids = main_hub.users.where(role: 'lc').pluck(:id) - [current_user.id]

        overlapping_leaves = StaffLeave.where(user_id: hub_lc_user_ids, status: ['pending', 'approved'], leave_type: leave_type)
                                              .where.not("end_date < ? OR start_date > ?", start_date, end_date)

        overlapping_leaves.each do |leave|
          status = leave.status
          date_range = "#{leave.start_date} to #{leave.end_date}"
          user_name = leave.user.full_name || "A user"
          hub_name = main_hub.name
          overlapping_messages << "#{user_name} of your hub #{hub_name} has already a #{status} #{leave_type} on #{date_range}."
        end
      else
        current_user.departments.each do |dept|
          dept_user_ids = dept.user_ids - [current_user.id]
          overlapping_leaves = StaffLeave.where(user_id: dept_user_ids,
                                                status: ['pending', 'approved'],
                                                leave_type: leave_type)
                                        .where.not("end_date < ? OR start_date > ?", start_date, end_date)
          overlapping_leaves.each do |leave|
            status = leave.status
            date_range = "#{leave.start_date} to #{leave.end_date}"
            user_name = leave.user.full_name || "A user"
            dept_name = dept.name
            overlapping_messages << "#{user_name} of your #{dept_name} department has already a #{status} #{leave_type} on #{date_range}."
          end
        end
      end
    end

    # Unified self-overlap check
    overlapping_conflict = false
    overlapping_conflict_messages = []

    overlapping_leaves = current_user.staff_leaves.where(status: ['pending', 'approved'])
                                              .where.not("end_date < ? OR start_date > ?", start_date, end_date)
    if overlapping_leaves.exists?
      overlapping_conflict = true
      overlapping_conflict_messages = overlapping_leaves.map do |leave|
        "You already have a #{leave.leave_type.titleize} (#{leave.status}) scheduled from #{leave.start_date} to #{leave.end_date}. Please cancel it before proceeding with this request."
      end
    end

    # Additional checks for marriage leave (lifetime unique, even non-overlapping)
    if leave_type == 'marriage leave'
      if staff_leave.total_days.to_i > 15
        overlapping_conflict = true
        overlapping_conflict_messages << "Marriage leave cannot exceed 15 consecutive days."
      end
      if current_user.staff_leaves.where(leave_type: 'marriage leave', status: ['pending', 'approved']).exists?
        overlapping_conflict = true
        overlapping_conflict_messages << "You have already requested or taken marriage leave."
      end
    end

    sum_entitlements = entitlements_by_year.values.sum
    sum_possible_carry = jan_mar_segments.map { |s| s[:previous_year_carry].to_i }.sum
    total_available_including_possible_carry = sum_entitlements + sum_possible_carry

    exceeds = false
    if leave_type == 'holiday'
      exceeds = staff_leave.total_days.to_i > total_available_including_possible_carry
    end

    notes_message = leave_type == 'other' ? "This request spans #{staff_leave.total_days.to_i} consecutive days (including weekends/holidays). Provide details in notes." : nil

    render json: {
      total_days: staff_leave.total_days.to_i,
      days_by_year: days_by_year,
      jan_mar_segments: jan_mar_segments,
      entitlements_by_year: entitlements_by_year,
      exceeds: exceeds,
      blocked: blocked,
      blocked_messages: blocked_messages,
      overlapping_messages: overlapping_messages.uniq,
      overlapping_conflict: overlapping_conflict,
      overlapping_conflict_messages: overlapping_conflict_messages,
      notes_message: notes_message
    }
  rescue => e
    Rails.logger.error "Leaves#preview error: #{e.class} #{e.message}\n#{e.backtrace.first(10).join("\n")}"
    render json: { error: "Unexpected error" }, status: 500
  end

  def cancel
    @staff_leave = current_user.staff_leaves.find(params[:id])

    if @staff_leave.status == 'cancelled'
      redirect_to leaves_path, alert: 'Leave is already cancelled.' and return
    end

    chain = @staff_leave.approval_chain || []
    approved_confs = @staff_leave.confirmations.where(status: 'approved').order(:updated_at)
    pending_cancellation_exists = @staff_leave.confirmations.pending.where(type: 'CancellationConfirmation').exists?

    # If leave is pending and nobody approved -> immediate cancel as before
    if @staff_leave.status == 'pending' && approved_confs.none?
      ActiveRecord::Base.transaction do
        @staff_leave.confirmations.update!(read: true)
        @staff_leave.update!(status: 'cancelled')
      end
      redirect_to leaves_path, notice: 'Pending leave cancelled.' and return
    end

    # From here on: either leave was 'approved' OR 'pending' but some approvals exist.
    days_until_start = (@staff_leave.start_date - Date.current).to_i

    if days_until_start < 16
      exception_requested = ActiveModel::Type::Boolean.new.cast(params[:exception_requested])
      exception_reason = params[:exception_reason].to_s.strip

      unless exception_requested && exception_reason.present?
        redirect_to leaves_path, alert: 'To request cancellation within 16 days you must request an exception and provide a justification.' and return
      end
    else
      exception_requested = ActiveModel::Type::Boolean.new.cast(params[:exception_requested]) || false
      exception_reason = params[:exception_reason].to_s.strip.presence
    end

    if pending_cancellation_exists
      redirect_to leaves_path, alert: 'There is already a pending cancellation request for this leave.' and return
    end

    ActiveRecord::Base.transaction do
      if exception_requested || exception_reason.present?
        @staff_leave.update!(exception_requested: true, exception_reason: exception_reason)
      end

      if chain.blank?
        # No approvers -> immediate cancel
        @staff_leave.update!(status: 'cancelled')
      elsif approved_confs.none?
        # No approvals yet -> immediate cancel and clean up pending confirmations
        @staff_leave.confirmations.where(status: 'pending', type: 'Confirmation').find_each do |conf|
          begin
            link = Rails.application.routes.url_helpers.leaves_path(active_tab: 'manager') + "#confirmation-#{conf.id}"
            Notification.where(user: conf.approver, link: link).update!(read: true)
          rescue => _e
            # Silent catch; best-effort cleanup
          end
          conf.destroy
        end
        @staff_leave.update!(status: 'cancelled')
      else
        # Send cancellation to the first approver who has already approved
        target_approver = approved_confs.first.approver
        # Clean up any pending original confirmations
        @staff_leave.confirmations.where(status: 'pending', type: 'Confirmation').find_each do |conf|
          begin
            link = Rails.application.routes.url_helpers.leaves_path(active_tab: 'manager') + "#confirmation-#{conf.id}"
            Notification.where(user: conf.approver, link: link).update!(read: true)
          rescue => _e
            # Silent catch; best-effort cleanup
          end
          conf.destroy
        end
        # Create the cancellation confirmation for the first approver
        @staff_leave.confirmations.create!(
          type: 'CancellationConfirmation',
          approver: target_approver,
          status: 'pending'
        )
      end
    end

    redirect_to leaves_path, notice: 'Cancellation request sent to managers for approval.'
  rescue ActiveRecord::RecordNotFound
    redirect_to leaves_path, alert: 'Leave not found.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to leaves_path, alert: "Could not process cancellation: #{e.message}"
  end

  def approve_confirmation
    confirmation = current_user.confirmations.find(params[:id])
    confirmation.update(status: 'approved', validated_at: Time.now)
    redirect_to leaves_path(active_tab: 'manager'), notice: 'Confirmation approved.'
  end

  def reject_confirmation
    confirmation = current_user.confirmations.find(params[:id])

    # capture provided reason (may be nil)
    reason = params[:rejection_reason].to_s.strip.presence

    confirmation.update!(
      status: 'rejected',
      validated_at: Time.current,
      rejection_reason: reason
    )

    redirect_to leaves_path(active_tab: 'manager'), notice: 'Confirmation rejected.'
  rescue ActiveRecord::RecordNotFound
    redirect_to leaves_path(active_tab: 'manager'), alert: 'Confirmation not found or you are not authorized.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to leaves_path(active_tab: 'manager'), alert: "Could not reject confirmation: #{e.record.errors.full_messages.to_sentence}"
  end

  def update_entitlement
    user_id = params[:user_id]
    year = params[:year].to_i
    annual_total = [params[:annual_total].to_i, 0].max
    new_holidays_left = [params[:new_holidays_left].to_i, 0].max

    user = User.find(user_id)

    # Authorize: check if user is in managed departments' subtree
    authorized = current_user.managed_departments.any? do |d|
      user.departments.any? { |ud| d.subtree_ids.include?(ud.id) }
    end

    unless authorized
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    entitlement = StaffLeaveEntitlement.find_or_initialize_by(user: user, year: year)
    entitlement.annual_holidays = annual_total
    entitlement.holidays_left = new_holidays_left
    if entitlement.save
      render json: { success: true }
    else
      render json: { error: entitlement.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def staff_leave_params
    params.require(:staff_leave).permit(:leave_type, :start_date, :end_date, :exception_requested, :exception_reason, :notes, :exception_errors, :days_from_previous_year)
  end

  def prepare_manager_entitlements
    year_now = Date.current.year
    next_year = year_now + 1

    # collect ids for all managed departments (including their sub-departments)
    managed = current_user.managed_departments.to_a
    managed_ids = managed.flat_map { |d| d.subtree_ids }.uniq

    # list of departments to build filter dropdown (only those under manager)
    @managed_departments = Department.where(id: managed_ids).order(:name)

    # Optional server-side filter: only show users who belong to selected department subtree
    if params[:department_id].present? && managed_ids.include?(params[:department_id].to_i)
      selected_dept = Department.find(params[:department_id])
      visible_dept_ids = selected_dept.subtree_ids
    else
      visible_dept_ids = managed_ids
    end

    # fetch users who belong to any of the visible departments
    # preload departments to avoid N+1 when calling user.departments
    @dept_users = User.joins(:users_departments)
                      .where(users_departments: { department_id: visible_dept_ids })
                      .includes(:departments)
                      .distinct
                      .order('users.full_name')

    user_ids = @dept_users.map(&:id)
    @rows = []
    return if user_ids.empty?

    entitlements_by_user = StaffLeaveEntitlement.where(user_id: user_ids, year: year_now).index_by(&:user_id)

    # aggregated sums grouped by user_id
    pending_current = StaffLeave.where(user_id: user_ids, leave_type: 'holiday', status: 'pending')
                                .where("extract(year from start_date) = ?", year_now)
                                .group(:user_id).sum(:total_days)

    booked_current  = StaffLeave.where(user_id: user_ids, leave_type: 'holiday', status: 'approved')
                                .where("extract(year from start_date) = ?", year_now)
                                .group(:user_id).sum(:total_days)

    pending_carry = StaffLeave.where(user_id: user_ids, leave_type: 'holiday', status: 'pending')
                              .where("extract(year from start_date) = ?", next_year)
                              .group(:user_id).sum(:days_from_previous_year)

    booked_carry  = StaffLeave.where(user_id: user_ids, leave_type: 'holiday', status: 'approved')
                              .where("extract(year from start_date) = ?", next_year)
                              .group(:user_id).sum(:days_from_previous_year)

    @rows = @dept_users.map do |u|
      entitlement = entitlements_by_user[u.id]

      total_holidays = entitlement&.annual_holidays || 25
      pc = pending_current[u.id] || 0
      bc = booked_current[u.id]  || 0
      pco = pending_carry[u.id]  || 0
      bco = booked_carry[u.id]   || 0

      pending_holiday = pc + pco
      booked_holiday  = bc + bco

      if entitlement
        holidays_left = [entitlement.holidays_left || total_holidays - booked_holiday, 0].max
      else
        holidays_left = [total_holidays - booked_holiday, 0].max
      end

      primary_dept = u.departments.first # choose a "primary" department - change as appropriate

      {
        user: u,
        departments: u.departments.to_a,      # already preloaded
        primary_department: primary_dept,
        holidays_left: holidays_left,
        booked_holiday: booked_holiday,
        pending_holiday: pending_holiday,
        booked_carry_over: bco,
        pending_carry_over: pco,
        total_holidays: total_holidays
      }
    end
  end
end
