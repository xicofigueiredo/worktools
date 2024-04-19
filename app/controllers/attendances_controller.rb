require 'date'

class AttendancesController < ApplicationController
  def attendance
    create_daily_attendance()
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @prev_date = calculate_prev_date(@current_date, 'daily')
    @next_date = calculate_next_date(@current_date, 'daily')
    @attendances = fetch_daily_attendances(@current_date)
    @is_today = @attendances ? @attendances.first.attendance_date == Date.today : false;
    @has_learners = User.joins(:hubs).where(hubs: { id: current_user.hubs.first.id }, role: 'learner').exists?
  end

  def index
    current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @prev_date = calculate_prev_date(current_date, 'weekly')
    @next_date = calculate_next_date(current_date, 'weekly')
    @time_frame = 'Weekly'
    @daily_grouped_attendances = fetch_weekly_attendances(current_date)
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

    redirect_back(fallback_location: attendance_path, notice: "Attendance updated successfully")
  end

  def update_absence
    attendance = Attendance.find(params[:id])
    attendance.update(absence: params[:absence])
    if params[:absense] != 'Present'
      attendance.update(start_time: nil, end_time: nil)
    end
    redirect_back(fallback_location: attendance_path, notice: "Absence updated successfully")
  end

  def update_start_time
    attendance = Attendance.find(params[:id])
    if attendance.update(start_time: params[:attendance][:start_time])
      attendance.update(absence: 'Present')
      redirect_back(fallback_location: attendance_path, notice: "Attendance start time updated successfully")
    else
      redirect_back(fallback_location: attendance_path, alert: "Failed to update attendance start time")
    end
  end

  def update_end_time
    attendance = Attendance.find(params[:id])
    if attendance.update(end_time: params[:attendance][:end_time])
      redirect_back(fallback_location: attendance_path, notice: "Attendance end time updated successfully")
    else
      redirect_back(fallback_location: attendance_path, alert: "Failed to update attendance end time")
    end
  end

  def update_comments
    attendance = Attendance.find(params[:id])
    if attendance.update(comments: params[:attendance][:comments])
      redirect_back(fallback_location: attendance_path, notice: "Attendance comments updated successfully")
    else
      redirect_back(fallback_location: attendance_path, alert: "Failed to update attendance comments")
    end
  end

  def learner_attendances
    @learner = User.find(params[:learner_id])
    @attendances = @learner.attendances.where("attendance_date <= ?", Date.today).order(attendance_date: :desc)
  end

  private

  def attendance_params
    params.require(:attendance).permit(:start_time, :end_time, :comments)
  end

  def create_daily_attendance
    learners = User.where(role: 'learner')
    current_date = Date.today


    learners.each do |learner|
      # Check if the learner already has an attendance record for the current day
      attendance = learner.attendances.find_by(attendance_date: current_date)

      # If not, create one
      if attendance.nil?
        learner.attendances.create(attendance_date: current_date, absence: 'Unjustified Leave')
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
          learner.attendances.create(attendance_date: date, absence: 'Unjustified Leave')
        end
      end
    end
  end

  def ensure_daily_attendance_records(date)
    learners = User.joins(:hubs).where(hubs: { id: current_user.hubs.first.id }, role: 'learner')
    learners.each do |learner|
      unless learner.attendances.exists?(attendance_date: date)
        learner.attendances.create(attendance_date: date, absence: 'Unjustified Leave')
      end
    end
  end

  def fetch_daily_attendances(date)
    ensure_daily_attendance_records(date)

    daily_attendances = Attendance.joins(user: :hubs)
                                   .where(users: { hubs: { id: current_user.hubs.first.id } },
                                          attendance_date: date)
                                   .order(:created_at)

    daily_attendances
  end

  def fetch_weekly_attendances(date)
    start_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    ensure_weekly_attendance_records(start_of_week, end_of_week)

    weekly_attendances = Attendance.joins(user: :hubs)
                                    .where(users: { hubs: { id: current_user.hubs.first.id } },
                                           attendance_date: start_of_week..end_of_week)
                                    .order('attendance_date, users.full_name ASC')

    weekly_attendances.group_by { |attendance| attendance.attendance_date }
  end

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
