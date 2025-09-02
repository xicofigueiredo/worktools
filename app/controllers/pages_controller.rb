require 'utilities/timeframe'

class PagesController < ApplicationController
  include WorkingDaysAndHolidays

  skip_before_action :authenticate_user!
  before_action :check_admin_role, only: [:dashboard_admin]
  before_action :check_lc_role,
                only: %i[dashboard_lc attendance attendances learner_attendances update_attendance
                         update_absence_attendance update_start_time_attendance update_end_time_attendance
                         update_comments_attendance]
  before_action :check_cm_role, only: %i[dashboard_cm cm_learners]
  before_action :set_learner, only: [:learner_profile]
  before_action :authorize_user, only: [:learner_profile]
  before_action :prepare_dashboard_data, only: [:learner_profile]

  def dashboard_admin
    @deactivated = User.where(deactivate: true, role: 'learner')
    @learners_without_hub = User.left_outer_joins(:users_hubs)
    .where(role: 'learner', deactivate: [false, nil])
    .where(users_hubs: { id: nil })
    @hubs = Hub.order(:name).includes(:users).map do |hub|
      {
        hub: hub,
        learners: hub.users.where(role: 'learner', deactivate: [false, nil]).order(:full_name)
      }
    end

    # @hubs = hubs_with_users.map do |hub|
    #   {
    #     "name" => hub.name,
    #     "users_count" => hub.users.size,  # Directly count users preloaded by 'includes'
    #     "users" => hub.users.as_json(
    #       only: [:id, :full_name, :role, :deactivate, :email],
    #       include: {
    #         hubs: { only: [:name] }  # Include each user's associated hubs with only the name field
    #       }
    #     )
    #   }
    # end
  end

  def hub_selection
    @hubs = current_user.hubs
  end

  def dashboard_lc
    redirect_to dashboard_dc_path if current_user.hubs.count > 1 && params[:hub_id].nil?

    if params[:hub_id].nil?
      @selected_hub = current_user.users_hubs.find_by(main: true)&.hub
    else
      @selected_hub = Hub.find_by(id: params[:hub_id])
    end

    @users = @selected_hub.users.where(role: 'learner', deactivate: [false, nil])
    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    @total_balance = {}
    @forms_completed = {} # Hash to store the number of forms completed by each learner

    @users.each do |user|
      total_balance_for_user = 0
      user.timelines.each do |timeline|
        total_balance_for_user += timeline.difference unless timeline.difference.nil?
      end
      user.topics_balance = total_balance_for_user
      user.save

      # Count the number of forms completed by the learner
      @forms_completed[user.id] = Response.joins(form_interrogation_join: :form)
                                          .where(user_id: user.id)
                                          .count
      @forms_completed[user.id] = @forms_completed[user.id] / 4
    end

    @users = @users.order(topics_balance: :asc)
  end

  def dashboard_cm
    redirect_to cm_learners_path if current_user.subjects.count <= 1 && params[:subject_id].nil?
    @subjects = current_user.subject_records.order(name: :asc)

    # Count users per subject
    @subject_user_counts = User.joins(:timelines)
                               .where(deactivate: [false, nil])
                               .where(timelines: { hidden: [false, nil] })
                               .group("timelines.subject_id")
                               .count
  end


  def cm_learners
    # Check if user has any subjects
    if current_user.subjects.empty?
      redirect_to root_path, alert: "No subjects assigned to your account, please message Luis"
      return
    end

    @selected_subject = if params[:subject_id].present?
                          Subject.find(params[:subject_id])
                        elsif current_user.subjects.any?
                          Subject.find(current_user.subjects.first)
                        else
                          nil
                        end

    # If still no subject found, redirect with error
    unless @selected_subject
      redirect_to root_path, alert: "Invalid subject selected."
      return
    end

    @users = User.joins(:timelines)
      .where(timelines: { subject_id: @selected_subject.id, hidden: false })
      .where(deactivate: false)

    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first

    # dropdown por nome
    # ordenar por topicos apenas pela disciplina do cm
    # apagar icones de sg wg etc... e por attendance

    @total_balance = {}

    @users.each do |user|
      total_balance_for_user = 0
      user.timelines.each do |timeline|
        total_balance_for_user += timeline.difference unless timeline.difference.nil?
      end
      user.topics_balance = total_balance_for_user
      user.save
    end

    @users = @users.order(topics_balance: :asc)

  end


  def dashboard_dc
    @hubs = current_user.hubs
  end

  def profile
    kids = current_user.kids.map { |kid| User.find_by(id: kid) }
    if current_user.role == "learner" || current_user.role == "admin"
      @learner = current_user
      @learner_flag = @learner.learner_flag
      @timelines = @learner.timelines.where(hidden: false)
      @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
      @current_sprint_weeks = @current_sprint.weeks.order(:start_date)
      @sprint_goals = @learner.sprint_goals.find_by(sprint: @current_sprint)
      @skills = @sprint_goals&.skills
      @communities = @sprint_goals&.communities
      @hub_lcs = []
      @hub_lcs = @learner.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc').reject do |lc|
        lc.hubs.count >= 3 || lc.deactivate
      end

      @sprint_presence = calc_sprint_presence(@learner, @current_sprint)

      @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
      @kdas_percentage = @current_sprint.count_kdas_total(@learner)

      @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }

      @current_week = Week.find_by("start_date <= ? AND end_date >= ?", Date.today, Date.today)

      @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }

      @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

      nearest_build_week = Week.where("start_date <= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
      @sprint_consent = Consent.find_by(user_id: @learner.id, sprint_id: @current_sprint&.id)
      @bw_consent = Consent.find_by(user_id: @learner.id, week_id: nearest_build_week&.id)
      @activities = @bw_consent.consent_activities.any? if @bw_consent
      
      get_kda_averages(@learner.kdas, @current_sprint)
      redirect_to some_fallback_path, alert: "Learner not found." unless @learner
    elsif current_user.role == "lc"
      redirect_to dashboard_lc_path
    elsif current_user.role == "guardian" && kids.count.positive?
      redirect_to learner_profile_path(kids.first)
    elsif current_user.role == "cm"
      redirect_to dashboard_cm_path
    else
      redirect_to about_path
    end
  end

  def edit_profile
    @hub = current_user.users_hub.hub
    @subject = current_user.timelines.first.subject
    @timelines = current_user.timelines
  end

  def update_profile
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit_profile
    end
  end

  def learner_profile
    # Only add logic here that is specific to the current user role.
    if current_user.role == 'guardian'
      @report = @learner.reports.order(updated_at: :asc).where(parent: true).last
      @last_report_sprint = @report&.sprint&.name || ""
    end
    nearest_build_week = Week.where("start_date <= ? AND name ILIKE ?", Date.today, "%Build%").order(:start_date).first
    @sprint_consent = Consent.find_by(user_id: @learner.id, sprint_id: @current_sprint&.id)
    @bw_consent = Consent.find_by(user_id: @learner.id, week_id: nearest_build_week&.id)
    @activities = @bw_consent.consent_activities.any? if @bw_consent
    # The bulk of the setup is already handled in prepare_dashboard_data.
  end

  # app/controllers/pages_controller.rb
  def change_weekly_attendance
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    week = Week.find_by("start_date <= ? AND end_date >= ?", date, date)
    learner = User.find_by(id: params[:learner_id])

    if learner.nil? || week.nil?
      render turbo_stream: turbo_stream.replace("lp_weekly_attendance", partial: "pages/partials/error_message",
                                                                        locals: { message: "Learner or week not found" })
      return
    end

    attendances = learner.attendances.where(attendance_date: week.start_date..week.end_date)

    render turbo_stream:
      turbo_stream.replace("lp_weekly_attendance",
                           partial: "pages/partials/attendance",
                           locals: { attendances:, current_week: week, learner:,
                                     current_date: date })
  end

  def change_weekly_goal
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    week = Week.find_by("start_date <= ? AND end_date >= ?", date, date)
    learner = User.find_by(id: params[:learner_id])
    params[:current_date] ? Date.parse(params[:current_date]) : Date.today
    weekly_goal = learner.weekly_goals.joins(:week).find_by("weeks.start_date <= ? AND weeks.end_date >= ?", date, date)
    @current_week_sprint_name = Sprint.where(id: week.sprint_id).pluck(:name).first if week

    update_weekly_goal(weekly_goal, week, learner, date)
  end

  def change_kda
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    week = Week.find_by("start_date <= ? AND end_date >= ?", date, date)
    learner = User.find_by(id: params[:learner_id])
    params[:current_date] ? Date.parse(params[:current_date]) : Date.today
    kda = learner.kdas.joins(:week).find_by("weeks.start_date <= ? AND weeks.end_date >= ?", date, date)
    @current_week_sprint_name = Sprint.where(id: week.sprint_id).pluck(:name).first if week

    update_kda(kda, week, learner, date)
  end

  def change_sprint_goal
    sprint = Sprint.find_by(id: params[:current_sprint_id])
    learner = User.find_by(id: params[:learner_id])

    if sprint.nil?
      Rails.logger.error "❌ No Sprint found for ID: #{params[:current_sprint_id]}"
      flash[:alert] = "Sprint not found!"
      redirect_to root_path and return
    end

    if learner.nil?
      Rails.logger.error "❌ Learner not found for ID: #{params[:learner_id]}"
      flash[:alert] = "Learner not found!"
      redirect_to root_path and return
    end

    sprint_goal = learner.sprint_goals.find_by(sprint_id: sprint.id)

    if sprint_goal.nil?
      Rails.logger.info "ℹ️ No sprint goal found for learner ID: #{learner.id} on sprint ID: #{sprint.id}"
    end

    update_sprint_goal(sprint_goal, sprint, learner)
  end

  def not_found
    render 'not_found', status: :not_found
  end

  def update_learner_name
    @learner = User.find_by(id: params[:id])

    unless current_user.role == 'admin' || current_user.role == 'lc'
      redirect_to root_path, alert: "You don't have permission to edit this learner's name." and return
    end

    if @learner.update(learner_params)
      redirect_to learner_profile_path(@learner), notice: "Learner name updated successfully."
    else
      redirect_to learner_profile_path(@learner), alert: "Failed to update learner name: #{@learner.errors.full_messages.join(', ')}"
    end
  end

  private

  def learner_params
    params.require(:user).permit(:full_name)
  end

  def update_weekly_goal(weekly_goal, week, learner, date)
    render turbo_stream:
      turbo_stream.replace("lp_weekly_goal",
                           partial: "pages/partials/weekly_goals",
                           locals: { weekly_goal:,
                                     current_week: week,
                                     learner:,
                                     current_date: date,
                                     current_week_sprint_name: @current_week_sprint_name
                                    })
  end

  def update_kda(kda, week, learner, date)
    render turbo_stream:
      turbo_stream.replace("lp_kda",
                           partial: "pages/partials/kdas",
                           locals: { kda:,
                                     current_week: week,
                                     learner:,
                                     current_date: date,
                                     current_week_sprint_name: @current_week_sprint_name
                                    })
  end

  def update_sprint_goal(sprint_goal, sprint, learner)
    render turbo_stream:
      turbo_stream.replace("lp_sprint_goal",
                           partial: "pages/partials/skills_and_communities",
                           locals: { sprint_goal: sprint_goal,
                                     current_sprint: sprint,
                                     learner: learner })
  end

  def user_params
    params.require(:user).permit(:full_name, :hub_id)
  end

  def get_kda_averages(kdas, current_sprint)
    sum_mot = 0
    sum_p2p = 0
    sum_ini = 0
    sum_hubp = 0
    sum_sdl = 0

    filtered_kdas = kdas.filter do |kda|
      kda.week.sprint == current_sprint
    end

    filtered_kdas.each do |kda|
      sum_mot += kda.mot.rating
      sum_p2p += kda.p2p.rating
      sum_ini += kda.ini.rating
      sum_hubp += kda.hubp.rating
      sum_sdl += kda.sdl.rating
    end

    kdas_count = filtered_kdas.count

    # Calculate averages
    avg_mot = kdas_count.positive? ? sum_mot.to_f.round / kdas_count : 0
    avg_p2p = kdas_count.positive? ? sum_p2p.to_f.round / kdas_count : 0
    avg_ini = kdas_count.positive? ? sum_ini.to_f.round / kdas_count : 0
    avg_hubp = kdas_count.positive? ? sum_hubp.to_f.round / kdas_count : 0
    avg_sdl = kdas_count.positive? ? sum_sdl.to_f.round / kdas_count : 0

    @average_items = [
      { title: 'Self-Directed Learning', average: avg_sdl },
      { title: 'Motivation', average: avg_mot },
      { title: 'Initiative', average: avg_ini },
      { title: 'Hub Participation', average: avg_hubp },
      { title: 'Peer-to-Peer Learning', average: avg_p2p }
    ]
  end

  def check_admin_role
    return if current_user.role == "admin"

    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  def check_lc_role
    return if current_user.role == "lc" || current_user.role == "admin"

    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  def check_cm_role
    return if current_user.role == "cm" || current_user.role == "admin" || current_user.subjects.count >= 1

    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  def check_sprint_goal(user)
    result = false
    user.sprint_goals.find_by(sprint: Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today,
                                                     Date.today)).knowledges.each do |knowledge|
      if !knowledge.difficulties.nil? && !knowledge.plan.nil?
        result = true
      else
        result = false
      end
    end
    result
  end

  def calc_yearly_presence(user)
    current_year = Date.today.year
    start_of_year = Date.new(current_year, 1, 1)
    end_of_year = Date.new(current_year, 12, 31)

    yearly_sprints = Sprint.where(start_date: start_of_year..end_of_year)
    earliest_start_date = yearly_sprints.minimum(:start_date) || start_of_year

    date_range = earliest_start_date..Date.today

    # Group attendances by absence status with one query
    attendance_counts = Attendance.where(user_id: user.id, attendance_date: date_range)
                                  .group(:absence).count

    absence_count = attendance_counts['Unjustified Leave'].to_i + attendance_counts['Justified Leave'].to_i
    present_count = attendance_counts['Present'].to_i + attendance_counts['Working Away'].to_i

    total = present_count + absence_count
    total > 0 ? ((present_count.to_f / total) * 100).round : 0
  end

  def calc_sprint_presence(user, sprint)
    current_date = Date.today

    attendance_counts = Attendance.where(user_id: user.id, attendance_date: sprint.start_date..sprint.end_date)
                                  .group(:absence).count

    absence_count = attendance_counts['Unjustified Leave'].to_i + attendance_counts['Justified Leave'].to_i
    present_count = attendance_counts['Present'].to_i + attendance_counts['Working Away'].to_i

    total = present_count + absence_count
    total > 0 ? ((present_count.to_f / total) * 100).round : 0

  end



  def set_learner
    @learner = User.find_by(id: params[:id])
    redirect_to root_path and return if @learner.nil?
  end

  def authorize_user
    allowed_roles = %w(admin lc cm)
    unless current_user.kids.include?(@learner.id) || allowed_roles.include?(current_user.role)
      redirect_to root_path and return
    end
  end

  def prepare_dashboard_data
    today = Date.today
    date_threshold = today - 30.days
    @learner_flag = @learner.learner_flag
    @notes = if current_user.role != "cm"
              @learner.notes.where("date >= ?", date_threshold).order(created_at: :desc)
            else
              @learner.notes.where(category: "knowledge").where("date >= ?", date_threshold).order(created_at: :desc)
            end
    @timelines = @learner.timelines.where(hidden: false)

    @current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", today, today).first
    @current_sprint_weeks = @current_sprint.weeks.order(:start_date) if @current_sprint

    # Precompute weekly goals, KDAs, and absences for each week
    @weekly_goals_status = {}
    @kda_status = {}
    @absences_count = {}

    @current_sprint_weeks.each do |week|
      @weekly_goals_status[week.id] = week.weekly_goals.where(user: @learner).exists?
      @kda_status[week.id] = week.kdas.where(user: @learner).exists?
      @absences_count[week.id] = week.start_date <= today ? week.count_absences(@learner) : nil
    end

    # Use a single query for sprint goal based on today's date
    @sprint_goal = @learner.sprint_goals.joins(:sprint)
                           .find_by("sprints.start_date <= ? AND sprints.end_date >= ?", today, today)

    main_hub_id = UsersHub.where(user_id: @learner.id, main: true).pluck(:hub_id).first
    @main_hub = Hub.find_by(id: main_hub_id)
    @hub_lcs = fetch_hub_lcs(@main_hub)



    @holidays = @learner.holidays
    @sprint_presence = calc_sprint_presence(@learner, @current_sprint)
    @weekly_goals_percentage = @current_sprint.count_weekly_goals_total(@learner)
    @kdas_percentage = @current_sprint.count_kdas_total(@learner)
    @has_exam_date = @timelines.any? { |timeline| timeline.exam_date.present? }
    @has_mock50 = @timelines.any? { |timeline| timeline.mock50.present? }
    @has_mock100 = @timelines.any? { |timeline| timeline.mock50.present? }

    @current_weekly_goal_date = adjust_weekly_goal_date(today)
    @current_week = find_current_week(@current_weekly_goal_date)
    @current_week_sprint_name = Sprint.where(id: @current_week.sprint_id).pluck(:name).first if @current_week

    @weekly_goal = @learner.weekly_goals.joins(:week)
                          .find_by("weeks.start_date <= ? AND weeks.end_date >= ?", @current_weekly_goal_date, @current_weekly_goal_date)
    @attendances = @learner.attendances.where(attendance_date: @current_sprint.start_date..@current_sprint.end_date)

    @kda = @learner.kdas.joins(:week)
                          .find_by("weeks.start_date <= ? AND weeks.end_date >= ?", @current_weekly_goal_date, @current_weekly_goal_date)

    get_kda_averages(@learner.kdas, @current_sprint)

    @yearly_presence = calc_yearly_presence(@learner)
  end


  def fetch_hub_lcs(main_hub)
    return [] unless main_hub

    main_hub.users.where(role: 'lc')
                  .left_joins(:hubs)
                  .where(deactivate: [false, nil])
                  .group('users.id')
                  .having('COUNT(hubs.id) < 3')
  end


  def adjust_weekly_goal_date(date)
    if date.saturday?
      date - 1.day
    elsif date.sunday?
      date - 2.days
    else
      date
    end
  end

  def find_current_week(date)
    week = Week.find_by("start_date <= ? AND end_date >= ?", date, date)
    week || Week.find_by("start_date <= ? AND end_date >= ?", date + 14.days, date + 14.days)
  end

end
