class AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Get all subjects that have moodle_id (meaning they're connected to Moodle courses)
    @subjects = Subject.where.not(moodle_id: nil).order(:name)

    if params[:moodle_id].present?
      @selected_subject = Subject.find_by(moodle_id: params[:moodle_id])
      @course_id = @selected_subject.moodle_id

      # Get assignment data using our service
      service = MoodleApiService.new

      # Use the safer method that handles errors better
      @assignments_data = service.get_safe_assignments_from_activities(@course_id, max_users: 30)

      # Group by assignment for better display
      @assignments_grouped = @assignments_data.group_by { |data| data[:assignment_name] }
    end
  rescue => e
    flash[:alert] = "Error fetching assignments: #{e.message}"
    redirect_to assignments_path
  end

  def show_detailed
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    @course_id = @subject.moodle_id

    service = MoodleApiService.new

    # Try to get organized data, but fall back to activities if needed
    begin
      @detailed_data = service.get_organized_assignment_data(@course_id)
    rescue => e
      puts "Organized data failed, trying activities fallback: #{e.message}"
      @detailed_data = service.get_assignments_from_activities(@course_id, max_users: 50)
    end

    # Group by assignment
    @assignments_grouped = @detailed_data.group_by { |data| data[:assignment_name] }
  rescue => e
    flash[:alert] = "Error fetching detailed assignments: #{e.message}"
    redirect_to assignments_path
  end

  def assignment_statistics
    @subject = Subject.find_by(moodle_id: params[:moodle_id])
    @course_id = @subject.moodle_id

    service = MoodleApiService.new

    # Try standard API first, then fall back
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
