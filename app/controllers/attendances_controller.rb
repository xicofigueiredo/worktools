require 'date'

class AttendancesController < ApplicationController
  def attendance
    create_daily_attendance()
    @attendances = fetch_daily_attendances
    @is_today = @attendances.first.attendance_date == Date.today
    @learners = current_user.hubs.first.users_hub.map(&:user).select { |user| user.role == "learner" }
  end

  def index
    current_date = Date.today
    @prev_date = calculate_prev_date(current_date, params[:time_frame])
    @next_date = calculate_next_date(current_date, params[:time_frame])
    @time_frame = 'Weekly'
    @daily_grouped_attendances = fetch_weekly_attendances

  end

  def update_attendance
    learner = User.find(params[:learner_id])
    attendance_date = params[:attendance_date]
    attendance = learner.attendances.find_by(attendance_date: attendance_date)

    if attendance.nil?
      learner.attendances.create(attendance_date: attendance_date, start_time: Time.now, present: true, absence: 'Present')
    else
      # If start time is present but end time is not, set end time
      if attendance.start_time.present? && attendance.end_time.blank?
        attendance.update(end_time: Time.now)
      # If start time is not present, set start time
      elsif attendance.start_time.blank?
        attendance.update(start_time: Time.now, present: true, absence: 'Present')
      end
    end

    redirect_to attendance_path, notice: "Attendance updated successfully"
  end

  def save_comment
    attendance = Attendance.find(params[:id])
    attendance.update(comment_params)

    redirect_back(fallback_location: root_path, notice: "Comment saved successfully")
  end

  def update_absence
    attendance = Attendance.find(params[:id])
    attendance.update(absence: params[:absence])
    if params[:absense] != 'Present'
      attendance.update(start_time: nil, end_time: nil)
    end
    redirect_back(fallback_location: attendance_path, notice: "Absence updated successfully")
  end

  def update_time
    attendance = Attendance.find(params[:id])
    if attendance.update(time_params)
      attendance.update(absence: 'Present')
      redirect_back(fallback_location: attendance_path, notice: "Times updated successfully")
    else
      redirect_back(fallback_location: attendance_path, alert: "Failed to update times")
    end
  end

  def learner_attendances
    @learner = User.find(params[:learner_id])
    @attendances = @learner.attendances
  end

  private

  def comment_params
    params.require(:attendance).permit(:comments)
  end

  def time_params
    params.permit(:start_time, :end_time)
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
  end

  def ensure_weekly_attendance_records(start_date, end_date)
    learners = User.joins(:hubs).where(hubs: { id: current_user.hubs.first.id }, role: 'learner')
    (start_date..end_date).each do |date|
      # Checking for saturday and sunday
      next if date.wday == 6 || date.wday == 0

      learners.each do |learner|
        unless learner.attendances.exists?(attendance_date: date)
          learner.attendances.create(attendance_date: date)
        end
      end
    end
  end

  def fetch_daily_attendances
    date = Date.today
    Attendance.joins(user: :hubs).where(users: { hubs: { id: current_user.hubs } }, attendance_date: date)
  end

  def fetch_weekly_attendances
    start_of_week = Date.today.beginning_of_week
    end_of_week = Date.today.end_of_week
    ensure_weekly_attendance_records(start_of_week, end_of_week)

    weekly_attendances = Attendance.joins(user: :hubs)
                                    .where(users: { hubs: { id: current_user.hubs.first.id } },
                                           attendance_date: start_of_week..end_of_week)
                                    .order(:attendance_date)

    weekly_attendances.group_by { |attendance| attendance.attendance_date }
  end

  def fetch_monthly_attendances
    start_of_month = Date.today.beginning_of_month
    end_of_month = Date.today.end_of_month
    Attendance.joins(user: :hubs).where(users: { hubs: { id: current_user.hubs } }, attendance_date: start_of_month..end_of_month)
  end

  # In progress
  def calculate_prev_date(current_date, time_frame)
    case time_frame
    when 'daily'
      current_date - 1
    when 'weekly'
      current_date - 7
    else
      current_date
    end
  end

  # In progress
  def calculate_next_date(current_date, time_frame)
    case time_frame
    when 'daily'
      current_date + 1
    when 'weekly'
      current_date + 7
    else
      current_date
    end
  end

end
