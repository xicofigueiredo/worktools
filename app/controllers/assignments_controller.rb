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
end
