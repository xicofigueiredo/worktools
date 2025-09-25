class LeavesController < ApplicationController
  before_action :authenticate_user! if respond_to?(:authenticate_user!, true)
  ADVANCE_DAYS = StaffLeave::ADVANCE_DAYS

  def index
    @user_leaves = current_user.staff_leaves.order(created_at: :desc)

    @month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @next_month = @month.next_month
    @prev_month = @month.prev_month

    if current_user.managed_departments.present?
      @pending_confirmations = current_user.confirmations.pending

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

    if @staff_leave.save
      # Handle document uploads (only for sick leaves by default)
      # expects params[:staff_leave][:documents] (array of uploaded files)
      if @staff_leave.leave_type == 'sick leave' && params.dig(:staff_leave, :documents).present?
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

    leave_type = params[:leave_type]

    if end_date < start_date
      return render json: { error: "end_date must be the same or after start_date" }, status: :unprocessable_entity
    end

    staff_leave = StaffLeave.new(user: current_user, start_date: start_date, end_date: end_date, leave_type: leave_type)
    staff_leave.compute_total_days

    left_field = leave_type == 'holiday' ? :holidays_left : :sick_leaves_left

    # Build per-year counts and per-year entitlements
    years = (start_date.year..end_date.year).to_a
    days_by_year = {}
    entitlements_by_year = {}

    years.each do |yr|
      days_by_year[yr] = staff_leave.days_in_year(yr)

      ent = StaffLeaveEntitlement.find_or_initialize_by(user: current_user, year: yr)
      entitlements_by_year[yr] = ent.persisted? ? ent.send(left_field).to_i : (leave_type == 'holiday' ? 25 : 5)
    end

    # For every year in the range, check if the leave overlaps Jan 1..Mar 31 of that year.
    # If so, compute eligible carry days (business days inside that slice) and how many
    # of those could be provided from the previous year's entitlement (<= 5 rule).
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

      # previous-year available
      prev_year = yr - 1
      prev_ent = StaffLeaveEntitlement.find_by(user: current_user, year: prev_year)
      prev_holidays_left = prev_ent ? prev_ent.holidays_left.to_i : 0

      entitlement_for_this_year = StaffLeaveEntitlement.find_or_initialize_by(user: current_user, year: yr)
      days_from_previous_used = entitlement_for_this_year.persisted? ? entitlement_for_this_year.days_from_previous_year_used.to_i : 0

      # maximum that can be taken from previous year for this Jan-Mar slice:
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

    # Combined availability check (for soft messaging). We compute total available as:
    # sum(entitlements_by_year) + sum(previous_year_carry across jan-mar segments).
    sum_entitlements = entitlements_by_year.values.sum
    sum_possible_carry = jan_mar_segments.map { |s| s[:previous_year_carry].to_i }.sum
    total_available_including_possible_carry = sum_entitlements + sum_possible_carry

    exceeds = staff_leave.total_days.to_i > total_available_including_possible_carry

    # blocked periods (unchanged behaviour)
    hub_id = current_user.users_hubs.find_by(main: true)&.hub_id
    department_ids = current_user.department_ids
    user_type = current_user.role

    blocked_periods = BlockedPeriod.where("(user_id = ? OR user_type = ? OR hub_id = ? OR department_id IN (?)) AND
                                          start_date <= ? AND end_date >= ?",
                                          current_user.id, user_type, hub_id, department_ids, end_date, start_date)
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

    # department overlaps (unchanged)
    overlapping_messages = []
    current_user.departments.each do |dept|
      dept_user_ids = dept.user_ids - [current_user.id]
      overlapping_leaves = StaffLeave.where(user_id: dept_user_ids, status: ['pending', 'approved'], leave_type: leave_type)
                                    .where.not("end_date < ? OR start_date > ?", start_date, end_date)
      overlapping_leaves.each do |leave|
        status = leave.status
        date_range = "#{leave.start_date} to #{leave.end_date}"
        user_name = leave.user.full_name || "A user"
        dept_name = dept.name
        overlapping_messages << "#{user_name} of your #{dept_name} department has already a #{status} holiday on #{date_range}."
      end
    end

    overlapping_self = current_user.staff_leaves.where(status: ['pending', 'approved'], leave_type: leave_type)
                                              .where.not("end_date < ? OR start_date > ?", start_date, end_date).exists?
    overlapping_self_message = "You already have a pending or approved #{leave_type} in this period." if overlapping_self

    render json: {
      total_days: staff_leave.total_days.to_i,
      days_by_year: days_by_year,
      jan_mar_segments: jan_mar_segments,
      entitlements_by_year: entitlements_by_year,
      exceeds: exceeds,
      blocked: blocked,
      blocked_messages: blocked_messages,
      overlapping_messages: overlapping_messages.uniq,
      overlapping_self: overlapping_self,
      overlapping_self_message: overlapping_self_message
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
        # no approvers -> immediate cancel
        @staff_leave.update!(status: 'cancelled')
      else
        # Decide who to send the first CancellationConfirmation to:
        target_approver =
          if approved_confs.none?
            chain.first
          elsif approved_confs.count < chain.length
            # send to the most-recent approver who already approved
            approved_confs.last.approver
          else
            # all approved -> re-run the chain starting at the first approver
            chain.first
          end

        # --- CLEANUP: remove pending *original* confirmations so they don't overlap with the cancellation flow.
        # We only remove confirmations of type 'Confirmation' that are still pending.
        # Also try to delete the notification that was created for that confirmation (best-effort).
        @staff_leave.confirmations.where(status: 'pending', type: 'Confirmation').find_each do |conf|
          begin
            # build the same link used when notification was created (best-effort)
            link = Rails.application.routes.url_helpers.leaves_path(active_tab: 'manager') + "#confirmation-#{conf.id}"
          rescue => _e
            link = nil
          end

          Notification.where(user: conf.approver, link: link).update!(read: true) if link
          conf.destroy
        end

        # create the cancellation confirmation (first step of cancellation flow)
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

  private

  def staff_leave_params
    params.require(:staff_leave).permit(:leave_type, :start_date, :end_date, :exception_requested, :exception_reason, :notes, :exception_errors, :days_from_previous_year)
  end
end
