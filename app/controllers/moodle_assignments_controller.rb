class MoodleAssignmentsController < ApplicationController
  before_action :set_moodle_assignment, only: [:show]

  def index
    @moodle_assignments = MoodleAssignment.where(moodle_course_id: 2).order(created_at: :desc).limit(500)
  end

  def show
    @submissions = Submission.where(moodle_assignment_id: @moodle_assignment.id)
                             .order(grading_date: :desc, submission_date: :desc)

    @submissions_count = @submissions.count

    # Compute average grading turnaround (grading_date - submission_date) in seconds
    pairs = @submissions.where.not(grading_date: nil, submission_date: nil)
                        .pluck(:grading_date, :submission_date)
    if pairs.any?
      deltas = pairs.map { |grading_date, submission_date| grading_date - submission_date }
      @avg_grading_seconds = deltas.sum / deltas.size
    else
      @avg_grading_seconds = nil
    end

    # Compute business-day grading time per submission and overall average
    dated_submissions = @submissions.where.not(grading_date: nil, submission_date: nil)
    if dated_submissions.exists?
      range_start = dated_submissions.minimum(:submission_date).to_date
      range_end   = dated_submissions.maximum(:grading_date).to_date

      # Public holidays across the whole range (global/default set)
      holiday_dates = PublicHoliday.dates_for_range(hub: nil, start_date: range_start, end_date: range_end).to_set

      @grading_business_days_by_submission_id = {}
      total_bd = 0
      count_bd = 0

      dated_submissions.find_each do |sub|
        bd = business_days_between(sub.submission_date, sub.grading_date, holiday_dates)
        @grading_business_days_by_submission_id[sub.id] = bd
        total_bd += bd
        count_bd += 1
      end

      @avg_grading_business_days = count_bd > 0 ? (total_bd.to_f / count_bd) : nil
    else
      @grading_business_days_by_submission_id = {}
      @avg_grading_business_days = nil
    end
  end

  private

  def set_moodle_assignment
    @moodle_assignment = MoodleAssignment.find(params[:id])
  end

  # Counts business days (Mon-Fri) between two datetimes, excluding provided holiday dates
  # Uses date boundaries only (time-of-day ignored)
  def business_days_between(start_time, end_time, holiday_dates)
    return 0 if start_time.blank? || end_time.blank?
    start_date = start_time.to_date
    end_date = end_time.to_date
    return 0 if end_date < start_date

    count = 0
    (start_date..end_date).each do |d|
      next if d.saturday? || d.sunday?
      next if holiday_dates.include?(d)
      count += 1
    end
    count
  end
end
