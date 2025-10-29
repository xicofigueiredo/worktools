require 'date'

class AttendancesController < ApplicationController
  def attendance
    create_daily_attendance
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @isweekend = @current_date.saturday? || @current_date.sunday?
    @prev_date = calculate_prev_date(@current_date, 'daily')
    @next_date = calculate_next_date(@current_date, 'daily')
    @attendances = fetch_daily_attendances(@current_date).sort_by { |attendance| attendance.user.full_name.downcase }
    @learners = User.joins(:hubs).where(hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner')
    @has_learners = @learners.exists?
    return unless @has_learners == true

    @is_today = @attendances ? @attendances&.first&.attendance_date == Date.today : false

    create_weekly_goals_notifications(@learners) if (1..5).include?(Date.today.wday)
  end

  def index
    current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @prev_date = calculate_prev_date(current_date, 'weekly')
    @next_date = calculate_next_date(current_date, 'weekly')
    @time_frame = 'Weekly'
    @daily_grouped_attendances = fetch_weekly_attendances(current_date)
    @has_learners = User.joins(:hubs).where(hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner').exists?
  end

  def update_attendance
    learner = User.find(params[:learner_id])
    attendance_date = params[:attendance_date]
    attendance = learner.attendances.find_by(attendance_date:)
    if attendance.nil?
      # Find the week for this date
      week = Week.where("start_date <= ? AND end_date >= ?", attendance_date.to_date, attendance_date.to_date).first
      # Find the weekly goal for this learner and week
      weekly_goal = learner.weekly_goals.find_by(week: week) if week
      # Create attendance and associate with weekly goal
      learner.attendances.create(attendance_date:, week_id: week&.id, start_time: Time.now, present: true,
                                 absence: 'Present', weekly_goal_id: weekly_goal&.id)
    elsif attendance.start_time.present? && attendance.end_time.blank?
      attendance.update(end_time: Time.now)
    elsif attendance.start_time.blank?
      attendance.update(start_time: Time.now, present: true, absence: 'Present')
    end

    redirect_back(fallback_location: attendance_path, notice: "Attendance updated successfully")
  end

  def update_absence
    attendance = Attendance.find(params[:id])
    if params[:attendance][:absence].blank?
      attendance.update(absence: nil)
    else
      attendance.update(absence: params[:attendance][:absence])
    end
    attendance.update(start_time: nil, end_time: nil) if params[:absence] != 'Present'

    render json: { status: "success", message: "Absence updated successfully" }
  end

  def update_start_time
    attendance = Attendance.find(params[:id])
    if attendance.update(start_time: params[:attendance][:start_time])
      attendance.update(absence: 'Present')
      render json: { status: "success", message: "Attendance start time updated successfully" }
    else
      render json: { status: "error", message: "Failed to update attendance start time" }, status: :unprocessable_entity
    end
  end

  def update_end_time
    attendance = Attendance.find(params[:id])
    if attendance.update(end_time: params[:attendance][:end_time])
      render json: { status: "success", message: "Attendance end time updated successfully" }
    else
      render json: { status: "error", message: "Failed to update attendance end time" }, status: :unprocessable_entity
    end
  end

  def update_comments
    attendance = Attendance.find(params[:id])
    if attendance.update(comments: params[:attendance][:comments])
      render json: { status: "success", message: "Attendance comments updated successfully" }
    else
      render json: { status: "error", message: "Failed to update attendance comments" }, status: :unprocessable_entity
    end
  end

  def learner_attendances
    @learner = User.find(params[:learner_id])
    @attendances = @learner.attendances.where("attendance_date <= ?", Date.today).order(attendance_date: :desc)
  end

  private

  def attendance_params
    params.require(:attendance).permit(:start_time, :end_time, :comments, :absence)
  end

  def create_daily_attendance
    current_date = Date.today

    return if current_date.saturday? || current_date.sunday?

    learners = User.where(role: 'learner', deactivate: false)

    learners.each do |learner|
      # Check if the learner already has an attendance record for the current day
      attendance = learner.attendances.find_by(attendance_date: current_date)

      # If not, create one
      if attendance.nil?
        # Find the week for this date
        week = Week.where("start_date <= ? AND end_date >= ?", current_date, current_date).first
        # Find the weekly goal for this learner and week
        weekly_goal = learner.weekly_goals.find_by(week: week) if week
        # Create attendance and associate with weekly goal
        learner.attendances.create(attendance_date: current_date, week_id: week&.id, weekly_goal_id: weekly_goal&.id)
      end
    end
  end

  def ensure_weekly_attendance_records(start_date, end_date)
    learners = User.joins(:hubs).where(hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner', deactivate: false)
    (start_date..end_date).each do |date|
      # Checking for saturday and sunday
      next if date.wday == 6 || date.wday.zero?

      learners.each do |learner|
        unless learner.attendances.exists?(attendance_date: date)
          # Find the week for this date
          week = Week.where("start_date <= ? AND end_date >= ?", date, date).first
          # Find the weekly goal for this learner and week
          weekly_goal = learner.weekly_goals.find_by(week: week) if week
          # Create attendance and associate with weekly goal
          learner.attendances.create(attendance_date: date, week_id: week&.id, weekly_goal_id: weekly_goal&.id)
        end
      end
    end
  end

  def ensure_daily_attendance_records(date)
    return if date.saturday? || date.sunday?

    learners = User.joins(:hubs).where(hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner', deactivate: false)
    learners.each do |learner|
      unless learner.attendances.exists?(attendance_date: date)
        # Find the week for this date
        week = Week.where("start_date <= ? AND end_date >= ?", date, date).first
        # Find the weekly goal for this learner and week
        weekly_goal = learner.weekly_goals.find_by(week: week) if week
        # Create attendance and associate with weekly goal
        learner.attendances.create(attendance_date: date, week_id: week&.id, weekly_goal_id: weekly_goal&.id)
      end
    end
  end

  def fetch_daily_attendances(date)
    ensure_daily_attendance_records(date)

    Attendance.joins(user: :hubs)
              .where(users: { hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner',
                              deactivate: false },
                     attendance_date: date)
              .order(:created_at)
  end

  def fetch_weekly_attendances(date)
    start_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    ensure_weekly_attendance_records(start_of_week, end_of_week)

    weekly_attendances = Attendance.joins(user: :hubs)
                                   .where(users: { hubs: { id: current_user.users_hubs.find_by(main: true)&.hub_id }, role: 'learner',
                                                   deactivate: false },
                                          attendance_date: start_of_week..end_of_week)
                                   .order('attendance_date, users.full_name ASC')

    weekly_attendances.group_by(&:attendance_date)
  end

  def calculate_prev_date(current_date, time_frame)
    case time_frame
    when 'daily'
      prev_date = current_date - 1
      prev_date -= 1 while prev_date.saturday? || prev_date.sunday?
      prev_date
    when 'weekly'
      prev_date = current_date - 7
      prev_date -= 1 while prev_date.saturday? || prev_date.sunday?
      prev_date
    else
      current_date
    end
  end

  def calculate_next_date(current_date, time_frame)
    case time_frame
    when 'daily'
      next_date = current_date + 1
      next_date += 1 while next_date.saturday? || next_date.sunday?
      next_date
    when 'weekly'
      next_date = current_date + 7
      next_date += 1 while next_date.saturday? || next_date.sunday?
      next_date
    else
      current_date
    end
  end

  def create_weekly_goals_notifications(learners)

    @today = Date.today
    @week = Week.where("start_date <= ? AND end_date >= ?", @today, @today).first
   @week_before = Week.where("start_date <= ? AND end_date >= ?", @today - 7.days, @today - 7.days).first

    return unless @week && @week_before

    lcs = current_user.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc', deactivate: false).select { |lc| lc.hubs.count < 4 }
    dcs = current_user.users_hubs.find_by(main: true)&.hub.users.where(role: 'dc', deactivate: false)

    learners.each do |learner|
      # Check if learner has weekly goals for current week
      current_week_has_goals = @week.weekly_goals.where(user: learner).exists?

      # Check if learner has weekly goals for previous week
      previous_week_has_goals = @week_before.weekly_goals.where(user: learner).exists?

      # If learner has no goals for both weeks, notify LCs
      unless current_week_has_goals && previous_week_has_goals
        lcs.each do |lc|
          Notification.find_or_create_by(
            user: lc,
            message: "Your learner #{learner.full_name} has not completed weekly goals for 2 consecutive weeks (#{@week_before.name} and #{@week.name}). Please follow up with them to ensure they stay on track.",
            link: learner_profile_path(learner)
          )
        end
      end
    end
  end

end
