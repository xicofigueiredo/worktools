class LeavesController < ApplicationController
  before_action :authenticate_user! if respond_to?(:authenticate_user!, true)
  ADVANCE_DAYS = StaffLeave::ADVANCE_DAYS

  def index
    @user_leaves = current_user.staff_leaves.order(created_at: :desc)

    @month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @next_month = @month.next_month
    @prev_month = @month.prev_month

    @show_hr_view = current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'

    # 1. Calculate Current User Entitlements for the View
    year_now = Date.current.year
    user_ent_data = calculate_user_entitlement_data(current_user, year_now)

    # Expose variables for _entitlements.html.erb
    @current_entitlement_total = user_ent_data[:total_holidays]
    @current_entitlement_left  = user_ent_data[:holidays_left]
    @current_mandatory_count   = user_ent_data[:mandatory_days]
    @current_voluntary_booked  = user_ent_data[:voluntary_booked]
    @current_pending_holiday   = user_ent_data[:pending_holiday]
    @current_booked_carry      = user_ent_data[:booked_carry_over]
    @current_pending_carry     = user_ent_data[:pending_carry_over]

    # 2. Manager View Logic
    if current_user.managed_departments.present?
      prepare_manager_entitlements if current_user&.managed_departments&.present?
      @pending_confirmations = current_user.confirmations.pending.where(confirmable_type: 'StaffLeave')

      depts = current_user.managed_departments
      is_top = depts.all? { |d| d.superior.nil? }

      if is_top
        @department_leaves = StaffLeave.where("start_date <= ? AND end_date >= ?", @month.end_of_month, @month)
                                      .where(status: ['pending', 'approved'])
                                      .order(start_date: :asc)
      else
        all_users = depts.flat_map { |dept| dept.all_users }.uniq
        @department_leaves = StaffLeave.where(user: all_users)
                                      .where("start_date <= ? AND end_date >= ?", @month.end_of_month, @month)
                                      .where(status: ['pending', 'approved'])
                                      .order(start_date: :asc)
      end
    else
      @pending_confirmations = []
      @department_leaves = []
    end

    # 3. HR Calendar Logic (Refactored to use Service)
    if @show_hr_view
      @hubs = Hub.all
      @departments = Department.all
      @users = User.staff

      # Determine Year for Calendar
      @year = params[:year] ? params[:year].to_i : Date.current.year

      # Resolve Filter Object
      hub_filter = params[:hub_filter].present? ? Hub.find_by(id: params[:hub_filter]) : nil

      # Call the Service
      service = CalendarDataService.new(
        year: @year,
        hub: hub_filter,
        country: params[:country_filter],
        department_id: params[:department_filter],
        type_filter: params[:type_filter]
      )

      data = service.call

      # Assign Data for the Shared Partial
      @holidays_by_date = data[:holidays]
      @blocked_by_date  = data[:blocked]
      @mandatory_leaves = data[:mandatory]

      # Initialize Objects for "Add Event" Modals
      @new_public_holiday = PublicHoliday.new
      @new_blocked_period = BlockedPeriod.new
      @new_mandatory_leave = MandatoryLeave.new
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

  def preview
    begin
      start_date = Date.parse(params[:start_date].to_s)
      end_date   = Date.parse(params[:end_date].to_s)
    rescue ArgumentError, TypeError
      return render json: { error: "Invalid dates" }, status: :unprocessable_entity
    end

    if end_date < start_date
      return render json: { error: "End date must be after start date" }, status: :unprocessable_entity
    end

    leave_type = params[:leave_type].to_s

    # 1. Total Days Calculation
    temp_leave = StaffLeave.new(user: current_user, start_date: start_date, end_date: end_date, leave_type: leave_type)
    temp_leave.calculate_total_days
    total_days_count = temp_leave.total_days.to_i

    # 2. Breakdown by Year
    years = (start_date.year..end_date.year).to_a
    days_by_year = {}
    years.each do |yr|
      y_start = [start_date, Date.new(yr, 1, 1)].max
      y_end   = [end_date, Date.new(yr, 12, 31)].min

      if y_start <= y_end
        y_leave = StaffLeave.new(user: current_user, start_date: y_start, end_date: y_end, leave_type: leave_type)
        y_leave.calculate_total_days
        days_by_year[yr] = y_leave.total_days.to_i
      else
        days_by_year[yr] = 0
      end
    end

    # 3. Entitlements Preview
    entitlements_by_year = {}
    years.each do |yr|
      ent = StaffLeaveEntitlement.find_or_initialize_by(user: current_user, year: yr)
      # Defaults if record missing
      val = ent.persisted? ? ent.holidays_left.to_i : 25
      entitlements_by_year[yr] = leave_type == 'holiday' ? val : 0
    end

    # 4. Carry-Over Logic
    jan_apr_segments = []

    if leave_type == 'holiday'
      years.each do |yr|
        # Only check carry over if we are looking at a future year relative to "Now"
        # AND strictly if yr is the End Date year (to simplify mapping)
        next unless Date.current.year < yr

        window_start = Date.new(yr, 1, 1)
        window_end   = Date.new(yr, 4, 30)

        overlap_start = [start_date, window_start].max
        overlap_end   = [end_date, window_end].min

        if overlap_start <= overlap_end
          overlap_leave = StaffLeave.new(user: current_user, start_date: overlap_start, end_date: overlap_end, leave_type: 'holiday')
          overlap_leave.calculate_total_days
          eligible_carry_days = overlap_leave.total_days.to_i

          if eligible_carry_days > 0
             prev_year = yr - 1
             prev_ent = StaffLeaveEntitlement.find_by(user: current_user, year: prev_year)
             curr_ent = StaffLeaveEntitlement.find_by(user: current_user, year: yr)

             prev_balance = prev_ent ? prev_ent.holidays_left.to_i : 0
             used_already = curr_ent ? curr_ent.days_from_previous_year_used.to_i : 0

             # Calculate Remaining Previous Balance taking into account THIS request's previous year consumption
             days_used_in_prev_year = days_by_year[prev_year] || 0
             real_prev_balance = [prev_balance - days_used_in_prev_year, 0].max

             # Capacity
             capacity = [5 - used_already, 0].max

             actual_available = [capacity, real_prev_balance].min

             if actual_available > 0
               jan_apr_segments << {
                 year: yr,
                 eligible_carry_days: eligible_carry_days,
                 previous_year_carry: actual_available,
                 previous_year: prev_year
               }
             end
          end
        end
      end
    end

    # 5. Errors / Soft Validation
    temp_leave.valid?
    blocked = temp_leave.errors.where(:base).any? { |e| e.message.include?("Blocked") }
    blocked_messages = []
    blocked_messages << "Period contains blocked dates." if blocked

    overlapping_conflict = temp_leave.errors.where(:base).any? { |e| e.message.include?("already have") }

    # Exceeds Check
    exceeds = false
    if leave_type == 'holiday'
      years.each do |yr|
        needed = days_by_year[yr] || 0
        available = entitlements_by_year[yr] || 0

        segment = jan_apr_segments.find { |s| s[:year] == yr }
        available += segment[:previous_year_carry] if segment

        exceeds = true if needed > available
      end
    end

    render json: {
      total_days: total_days_count,
      days_by_year: days_by_year,
      jan_apr_segments: jan_apr_segments,
      entitlements_by_year: entitlements_by_year,
      blocked: blocked,
      blocked_messages: blocked_messages,
      overlapping_conflict: overlapping_conflict,
      exceeds: exceeds
    }
  end

  def cancel
    @staff_leave = current_user.staff_leaves.find(params[:id])

    if Date.current.day > 15
      redirect_to leaves_path, alert: 'Cancellations are not allowed after the 15th of the month.' and return
    end

    if @staff_leave.status == 'cancelled'
      redirect_to leaves_path, alert: 'Leave is already cancelled.' and return
    end

    chain = @staff_leave.approval_chain || []
    approved_confs = @staff_leave.confirmations.where(status: 'approved').order(:updated_at)
    pending_cancellation_exists = @staff_leave.confirmations.pending.where(type: 'CancellationConfirmation').exists?

    # If leave is pending and nobody approved -> immediate cancel as before
    if @staff_leave.status == 'pending' && approved_confs.none?
      ActiveRecord::Base.transaction do
        @staff_leave.confirmations.update!(status: 'cancelled')
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

  def create_entitlement
    params = entitlement_params  # Use strong params
    user = User.find_by(id: params[:user_id])

    unless user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    result = StaffLeaveEntitlement.create_for_user(
      user: user,
      year: params[:year].to_i,
      annual_holidays: [params[:annual_holidays].to_i, 0].max,
      holidays_left: [params[:holidays_left].to_i, 0].max,
      manager: current_user
    )

    if result[:success]
      render json: { success: true }
    else
      render json: { error: result[:error] }, status: result[:status]
    end
  rescue => e
    Rails.logger.error "Create entitlement error: #{e.message}"
    render json: { error: 'Failed to create entitlement' }, status: :internal_server_error
  end

  def update_entitlement
    params = entitlement_params  # Use strong params
    user = User.find_by(id: params[:user_id])
    year = params[:year].to_i

    unless user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    entitlement = StaffLeaveEntitlement.find_or_initialize_by(user: user, year: year)

    if entitlement.new_record?
      result = StaffLeaveEntitlement.create_for_user(
        user: user,
        year: year,
        annual_holidays: [params[:annual_total].to_i, 0].max,
        holidays_left: [params[:new_holidays_left].to_i, 0].max,
        manager: current_user
      )
    else
      result = entitlement.update_for_manager(
        annual_holidays: [params[:annual_total].to_i, 0].max,
        holidays_left: [params[:new_holidays_left].to_i, 0].max,
        manager: current_user
      )
    end

    if result[:success]
      render json: { success: true }
    else
      render json: { error: result[:error] }, status: result[:status]
    end
  rescue => e
    Rails.logger.error "Update entitlement error: #{e.message}"
    render json: { error: 'Failed to update entitlement' }, status: :internal_server_error
  end

  def users_without_entitlement
    year = params[:year].presence&.to_i || Date.current.year  # Safety: Default to current year if missing

    users = StaffLeaveEntitlement.users_without_entitlement(nil, year)

    render json: {
      users: users.map { |u| { id: u.id, name: u.full_name } }
    }
  rescue => e
    Rails.logger.error "Error fetching users without entitlement: #{e.message}"
    render json: { error: 'Failed to load users' }, status: :internal_server_error
  end

  def prepare_manager_entitlements
    year_now = params[:year].present? ? params[:year].to_i : Date.current.year

    managed = current_user.managed_departments.to_a
    managed_ids = managed.flat_map { |d| d.subtree_ids }.uniq
    @managed_departments = Department.where(id: managed_ids).order(:name)

    if params[:department_id].present? && managed_ids.include?(params[:department_id].to_i)
      visible_dept_ids = Department.find(params[:department_id]).subtree_ids
    else
      visible_dept_ids = managed_ids
    end

    @dept_users = User.joins(:users_departments)
                      .where(users_departments: { department_id: visible_dept_ids })
                      .includes(:departments)
                      .distinct
                      .order('users.full_name')

    @rows = @dept_users.map do |u|
      calculate_user_entitlement_data(u, year_now)
    end
  end

  private

  def entitlement_params
    params.permit(:user_id, :year, :annual_holidays, :holidays_left, :annual_total, :new_holidays_left, :start_date)
  end

  def staff_leave_params
    params.require(:staff_leave).permit(:leave_type, :start_date, :end_date, :exception_requested, :exception_reason, :notes, :exception_errors, :days_from_previous_year)
  end

  def calculate_user_entitlement_data(user, year)
    entitlement = StaffLeaveEntitlement.find_by(user: user, year: year)
    total_holidays = entitlement&.annual_holidays || 25
    holidays_left = entitlement&.holidays_left || 25

    # 1. Fetch relevant leaves (Pending & Approved) that overlap this year
    # We fetch broadly and filter in Ruby to ensure split-year accuracy
    leaves = StaffLeave.where(user: user, leave_type: 'holiday', status: ['pending', 'approved'])
                       .where("start_date <= ? AND end_date >= ?", Date.new(year, 12, 31), Date.new(year, 1, 1))

    pending_days = 0
    booked_days = 0
    mandatory_days = 0

    # 2. Calculate "Booked Carry Over" (Days from THIS year used in NEXT year)
    # Query leaves where end_date is next year and carry > 0
    next_year = year + 1
    carry_out_leaves = StaffLeave.where(user: user, leave_type: 'holiday', status: ['pending', 'approved'])
                                 .where("extract(year from end_date) = ?", next_year)
                                 .where("days_from_previous_year > 0")

    pending_carry_out = 0
    booked_carry_out = 0

    carry_out_leaves.each do |l|
      carry_amt = l.days_from_previous_year.to_i
      if l.status == 'pending'
        pending_carry_out += carry_amt
      else
        booked_carry_out += carry_amt
      end
    end

    # 3. Iterate leaves to calculate cost strictly for THIS year
    leaves.each do |l|
      # Calculate days falling strictly in `year`
      days_in_yr = l.days_in_year(year)
      next if days_in_yr == 0

      cost = days_in_yr

      # ADJUSTMENT: If this leave used carry-over FROM PREVIOUS YEAR (year-1),
      # we must NOT count those carry-over days as a cost to THIS year.
      if l.days_from_previous_year.to_i > 0 && l.end_date.year == year
        # Reduce cost by carry amount (capped by days in this year)
        carry_used = [l.days_from_previous_year.to_i, days_in_yr].min
        cost -= carry_used
      end

      if l.mandatory_leave_id.present?
        # Mandatory leaves are always 'approved'
        mandatory_days += cost
      elsif l.status == 'pending'
        pending_days += cost
      elsif l.status == 'approved'
        booked_days += cost
      end
    end

    # 4. Add Carry-Out to Usage
    pending_days += pending_carry_out
    booked_days += booked_carry_out

    # Final Hash
    {
      user: user,
      departments: user.departments.to_a,
      primary_department: user.departments.first,

      total_holidays: total_holidays,
      holidays_left: holidays_left,

      mandatory_days: mandatory_days,
      voluntary_booked: booked_days,
      booked_holiday: booked_days + mandatory_days,
      pending_holiday: pending_days,

      booked_carry_over: booked_carry_out,
      pending_carry_over: pending_carry_out
    }
  end
end
