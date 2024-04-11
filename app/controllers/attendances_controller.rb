class AttendancesController < ApplicationController
  def attendance
    @learners = current_user.hubs.first.users_hub.map(&:user).select { |user| user.role == "learner" }
  end

  def create_daily_attendance
    learners = User.where(role: 'learner')
    current_date = Date.today


    learners.each do |learner|
      # Check if the learner already has an attendance record for the current day
      attendance = learner.attendances.find_by(attendance_date: current_date)

      # If not, create one
      if attendance.nil?
        learner.attendances.create(attendance_date: current_date)
      end
    end

    redirect_to attendance_path, notice: "Daily attendance records created successfully"
  end

  def update_attendance
    learner = User.find(params[:learner_id])
    attendance_date = params[:attendance_date]
    attendance = learner.attendances.find_by(attendance_date: attendance_date)

    if attendance.nil?
      learner.attendances.create(attendance_date: attendance_date, start_time: Time.now, present: true)
    else
      # If start time is present but end time is not, set end time
      if attendance.start_time.present? && attendance.end_time.blank?
        attendance.update(end_time: Time.now)
      # If start time is not present, set start time
      elsif attendance.start_time.blank?
        attendance.update(start_time: Time.now, present: true)
      end
    end

    redirect_to attendance_path, notice: "Attendance updated successfully"
  end

  def learner_attendances
    @learner = User.find(params[:learner_id])
    @attendances = @learner.attendances
  end

end
