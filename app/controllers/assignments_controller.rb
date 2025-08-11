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
end
