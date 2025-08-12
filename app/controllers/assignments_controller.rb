class AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Get all subjects that have moodle_id (meaning they're connected to Moodle courses)
    # Exclude subjects with "AS" in the name
    @subjects = Subject.where.not(moodle_id: nil)
                      .where.not("name ILIKE ?", "%AS%")
                      .order(:name)

    if params[:moodle_id].present?
      @selected_subject = Subject.find_by(moodle_id: params[:moodle_id])
      @course_id = @selected_subject.moodle_id

      # Only fetch course data if explicitly requested OR if learner is being selected
      if params[:load_course_data].present? || params[:learner_moodle_id].present?
        service = MoodleApiService.new

        # Get learners for the course
        @course_learners = service.get_course_learners(@course_id)
        @course_data_loaded = true

        # Only process assignment data if BOTH subject and learner are selected
        if params[:learner_moodle_id].present?
          @selected_learner = @course_learners.find { |l| l[:moodle_id].to_s == params[:learner_moodle_id].to_s }

          if @selected_learner
            # Get assignment data for ONLY this specific learner
            @learner_assignment_data = service.get_learner_assignment_data(@course_id, params[:learner_moodle_id].to_i)
          end
        end
      end
    end
  rescue => e
    flash[:alert] = "Error fetching assignments: #{e.message}"
    redirect_to assignments_path
  end

  def show_detailed
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    @course_id = @subject.moodle_id

    service = MoodleApiService.new

    begin
      @detailed_data = service.get_organized_assignment_data(@course_id)
    rescue => e
      puts "Organized data failed, trying activities fallback: #{e.message}"
      @detailed_data = service.get_assignments_from_activities(@course_id)
    end

    @assignments_grouped = @detailed_data.group_by { |data| data[:assignment_name] }
  rescue => e
    flash[:alert] = "Error fetching detailed assignments: #{e.message}"
    redirect_to assignments_path
  end

  def assignment_statistics
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    @course_id = @subject.moodle_id

    service = MoodleApiService.new

    begin
      assignments = service.fetch_course_assignments(@course_id)
      @assignment_stats = assignments.map do |assignment|
        {
          id: assignment['id'],
          name: assignment['name'],
          due_date: assignment['duedate'] > 0 ? Time.at(assignment['duedate']).strftime("%d %B %Y, %H:%M") : "No due date",
          max_grade: assignment['grade'],
          max_attempts: assignment['maxattempts']
        }
      end
    rescue => e
      puts "Assignment stats failed, using activities: #{e.message}"
      activities_data = service.get_assignments_from_activities(@course_id, max_users: 5)
      @assignment_stats = activities_data.group_by { |a| a[:assignment_name] }.map do |name, data|
        {
          name: name,
          submissions: data.size,
          avg_grade: data.map { |d| d[:grade] }.sum / data.size.to_f
        }
      end
    end
  rescue => e
    flash[:alert] = "Error fetching assignment statistics: #{e.message}"
    redirect_to assignments_path
  end

  def monthly_submissions
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    @course_id = @subject.moodle_id

    service = MoodleApiService.new

    begin
      # Use the much faster method that makes fewer API calls
      # This gets assignment data for ALL users now
      all_submissions = service.get_safe_assignments_from_activities(@course_id)

      # DEBUG: Let's see what we're getting
      Rails.logger.info "=== MONTHLY SUBMISSIONS DEBUG ==="
      Rails.logger.info "Course ID: #{@course_id}"
      Rails.logger.info "Total submissions found: #{all_submissions.count}"
      Rails.logger.info "Sample submissions: #{all_submissions.first(3).inspect}" if all_submissions.any?

      # Check submission dates
      submission_dates = all_submissions.map { |s| s[:submission_date] }.uniq
      Rails.logger.info "Unique submission dates: #{submission_dates.first(10)}"

      # Create monthly statistics from Jan 2022 to current month
      @monthly_stats = []
      start_date = Date.new(2022, 1, 1)
      current_month = start_date.beginning_of_month
      end_date = Date.current.end_of_month

      while current_month <= end_date
        # Count submissions for this month
        month_submissions = all_submissions.select do |submission|
          submission_date = parse_submission_date(submission[:submission_date])
          submission_date &&
          submission_date.year == current_month.year &&
          submission_date.month == current_month.month
        end

        Rails.logger.info "#{current_month.strftime('%b %Y')}: #{month_submissions.count} submissions" if month_submissions.any?

        @monthly_stats << {
          month: current_month.strftime("%b %y"),
          full_month: current_month.strftime("%B %Y"),
          submissions_count: month_submissions.count
        }

        current_month = current_month.next_month
      end

      # DEBUG: Show total breakdown
      Rails.logger.info "=== FINAL STATS ==="
      Rails.logger.info "Total months: #{@monthly_stats.count}"
      Rails.logger.info "Total submissions across all months: #{@monthly_stats.sum { |s| s[:submissions_count] }}"

    rescue => e
      Rails.logger.error "Error in monthly_submissions: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:alert] = "Error fetching monthly submissions: #{e.message}"
      redirect_to assignments_path
    end
  end

  def monthly_submissions_local
    @subject = Subject.find_by(moodle_id: params[:moodle_id]) || Subject.find_by(id: params[:subject_id])
    return redirect_to assignments_path, alert: 'Subject not found' unless @subject

    start_date = Date.new(2022, 1, 1).beginning_of_month
    end_date = Date.current.end_of_month

    @monthly_stats = []
    current_month = start_date
    while current_month <= end_date
      next_month = current_month.next_month
      # Base scope: this subject, submissions in this month, and never before Jan 2022
      month_scope = Assignment.where(subject_id: @subject.id)
                              .where.not(submission_date: nil)
                              .where('submission_date >= ?', start_date)
                              .where(submission_date: current_month...next_month)
      # Exclude auto-graded/instant corrections (< 5 minutes between submission and feedback)
      month_scope = month_scope.where("evaluation_date IS NULL OR evaluation_date - submission_date >= interval '5 minutes'")

      submissions_count = month_scope.count
      unique_learners = month_scope.distinct.count(:user_id)
      assignments_with_submissions = month_scope.distinct.count(:moodle_id)
      grades_scope = month_scope.where.not(grade: nil)
      avg_grade = grades_scope.any? ? (grades_scope.average(:grade).to_f.round(2)) : 0

      # SLA average in business days (only for records that have feedback)
      sla_scope = month_scope.where.not(evaluation_date: nil)
                             .where('evaluation_date >= ?', start_date)
      total_sla_days = 0.0
      sla_count = 0
      sla_scope.find_each(batch_size: 1000) do |rec|
        total_sla_days += business_days_between(rec.submission_date, rec.evaluation_date)
        sla_count += 1
      end
      avg_sla_days = sla_count.positive? ? (total_sla_days / sla_count.to_f).round(2) : 0.0

      @monthly_stats << {
        month: current_month.strftime('%b %y'),
        full_month: current_month.strftime('%B %Y'),
        submissions_count: submissions_count,
        unique_learners: unique_learners,
        assignments_with_submissions: assignments_with_submissions,
        average_grade: avg_grade,
        avg_sla_days: avg_sla_days
      }

      current_month = next_month
    end
  end

  def sync
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    return redirect_to assignments_path, alert: 'Subject not found' unless @subject

    course_id = @subject.moodle_id
    service = MoodleApiService.new

    begin
      # Fetch course-level assignments once
      assignments = service.fetch_course_assignments(course_id)
      if assignments.blank?
        return redirect_to assignments_path(moodle_id: @subject.moodle_id, load_course_data: 1), alert: "No assignments returned from Moodle for course ##{course_id}"
      end

      # Fetch all enrolled users in the course
      users = service.get_enrolled_users(course_id)
      return redirect_to assignments_path(moodle_id: @subject.moodle_id, load_course_data: 1), alert: "No enrolled users found for course ##{course_id}" if users.blank?

      created = 0
      updated = 0
      errors = []

      assignments.each do |a|
        assignment_id = a['id']

        users.each do |u|
          user = User.find_by(email: u['email'])
          next unless user # skip users not present in local DB

          # Fetch submission status for this user and assignment
          submission_data = service.fetch_submission_status(assignment_id, u['id'])
          attempt = submission_data && submission_data['lastattempt']
          submission = attempt && (attempt['submission'] || attempt['teamsubmission'])
          feedback = submission_data && submission_data['feedback']

          rec = Assignment.find_or_initialize_by(user_id: user.id, moodle_id: assignment_id)
          was_new = rec.new_record?

          rec.subject_id = @subject.id
          rec.moodle_course_id = course_id
          rec.cmid = a['cmid']
          rec.name = a['name']
          rec.intro = a['intro']
          rec.allow_submissions_from = (a['allowsubmissionsfromdate'].to_i > 0 ? Time.at(a['allowsubmissionsfromdate'].to_i) : nil)
          rec.due_date = (a['duedate'].to_i > 0 ? Time.at(a['duedate'].to_i) : nil)
          rec.cutoff_date = (a['cutoffdate'].to_i > 0 ? Time.at(a['cutoffdate'].to_i) : nil)
          rec.max_grade = a['grade']
          rec.max_attempts = a['maxattempts']

          # User-specific fields
          rec.submission_date = submission ? (submission['timecreated'].to_i > 0 ? Time.at(submission['timecreated'].to_i) : nil) : nil
          rec.evaluation_date = feedback && feedback['grade'] && feedback['grade']['timemodified'].to_i > 0 ? Time.at(feedback['grade']['timemodified'].to_i) : nil
          rec.grade = feedback && feedback['grade'] ? feedback['grade']['grade'].to_f : nil
          rec.number_attempts = submission ? submission['attemptnumber'].to_i + 1 : 0

          if rec.save
            was_new ? created += 1 : updated += 1
          else
            errors << { user: u['email'], moodle_id: assignment_id, errors: rec.errors.full_messages }
          end
        end
      end

      msg = "Synced per-user assignments: created #{created}, updated #{updated} (users: #{users.size}, assignments: #{assignments.size})"
      msg += ". Errors: #{errors.size}" if errors.any?
      flash_notice = errors.any? ? { alert: msg } : { notice: msg }

      redirect_to assignments_path(moodle_id: @subject.moodle_id, load_course_data: 1), flash: flash_notice
    rescue => e
      Rails.logger.error("Assignments sync failed: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}")
      redirect_to assignments_path, alert: "Sync failed: #{e.message}"
    end
  end

  private

  def parse_submission_date(date_string)
    return nil if date_string.blank? || date_string == 'No submission'

    begin
      # First, check if it's a Unix timestamp (most common case)
      if date_string.match(/^\d+$/) && date_string.to_i > 0
        return Time.at(date_string.to_i).to_datetime
      end

      # Handle formatted date strings
      if date_string.match(/\d{2} \w+ \d{4}, \d{2}:\d{2}/)
        DateTime.parse(date_string)
      elsif date_string.match(/\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}/)
        DateTime.strptime(date_string, "%d/%m/%Y %H:%M")
      else
        DateTime.parse(date_string)
      end
    rescue => e
      Rails.logger.warn "Failed to parse date: #{date_string} - #{e.message}"
      nil
    end
  end

  # Exact business-day difference (Mon-Fri), expressed in days with decimals
  def business_days_between(start_time, end_time)
    return 0.0 if start_time.blank? || end_time.blank?
    return 0.0 if end_time <= start_time

    total_seconds = 0
    day_cursor = start_time.beginning_of_day
    last_day = end_time.beginning_of_day

    while day_cursor <= last_day
      # Only count Monday-Friday
      unless day_cursor.saturday? || day_cursor.sunday?
        day_start = [day_cursor, start_time].max
        day_end = [day_cursor.end_of_day, end_time].min
        if day_end > day_start
          total_seconds += (day_end - day_start)
        end
      end
      day_cursor = day_cursor + 1.day
    end

    (total_seconds.to_f / 86_400.0)
  end
end
