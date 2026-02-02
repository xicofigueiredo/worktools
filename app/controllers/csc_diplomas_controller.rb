class CscDiplomasController < ApplicationController
  before_action :authenticate_user!

  def show
    # Determine sprint for filtering
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    # Fallback to current sprint if none found
    @sprint ||= Sprint.order(end_date: :desc).first

    if @sprint
      calc_nav_dates(@sprint)
      @has_prev_sprint = Sprint.exists?(['end_date < ?', @sprint.start_date])
      @has_next_sprint = Sprint.exists?(['start_date > ?', @sprint.end_date])
    end

    # Determine which learner's diploma to show based on role
    if current_user.role == 'learner'
      @learner = current_user
    elsif current_user.role == 'lc' || current_user.role == 'admin'
      # Get learners from LC's hubs
      hub_learner_ids = User.joins(:users_hubs)
        .where(users_hubs: { hub_id: current_user.hubs.ids })
        .where(role: 'learner')
        .where("users.deactivate = ? OR users.deactivate IS NULL", false)
        .pluck(:id)

      online_learner_ids = current_user.respond_to?(:online_learners) ? current_user.online_learners.pluck(:id) : []

      all_learner_ids = (hub_learner_ids + online_learner_ids).uniq

      @learners = User.joins("LEFT OUTER JOIN users_hubs ON users_hubs.user_id = users.id")
        .joins("LEFT OUTER JOIN hubs ON hubs.id = users_hubs.hub_id")
        .where(id: all_learner_ids, role: 'learner')
        .select('users.*, COALESCE(MAX(CASE WHEN users_hubs.main = true THEN hubs.name END), MAX(hubs.name), \'Online\') as hub_name')
        .group('users.id')
        .order('hub_name ASC, users.full_name ASC')

      @grouped_learners = @learners.group_by { |learner| learner.hub_name }

      if params[:learner_id].present?
        @learner = User.find_by(id: params[:learner_id])
      else
        @learner = @learners.first || current_user
      end
    else
      @learner = current_user
    end

    @csc_diploma = @learner.csc_diploma || @learner.create_csc_diploma

    # Get activities, optionally filtered by sprint
    activities_scope = @csc_diploma.csc_activities.includes(activitable: [:sprint_goal])

    if @sprint && params[:filter_sprint] != 'all'
      # Filter activities by sprint through their activitable's sprint_goal
      @csc_activities = activities_scope.where(hidden: false)
        .joins("LEFT JOIN skills ON csc_activities.activitable_type = 'Skill' AND csc_activities.activitable_id = skills.id")
        .joins("LEFT JOIN communities ON csc_activities.activitable_type = 'Community' AND csc_activities.activitable_id = communities.id")
        .joins("LEFT JOIN sprint_goals AS skill_sg ON skills.sprint_goal_id = skill_sg.id")
        .joins("LEFT JOIN sprint_goals AS community_sg ON communities.sprint_goal_id = community_sg.id")
        .joins("LEFT JOIN sprint_goals AS direct_sg ON csc_activities.activitable_type = 'SprintGoal' AND csc_activities.activitable_id = direct_sg.id")
        .where("skill_sg.sprint_id = ? OR community_sg.sprint_id = ? OR direct_sg.sprint_id = ?", @sprint.id, @sprint.id, @sprint.id)
        .order(created_at: :desc)
        .distinct

      @hidden_activities = activities_scope.where(hidden: true)
        .joins("LEFT JOIN skills ON csc_activities.activitable_type = 'Skill' AND csc_activities.activitable_id = skills.id")
        .joins("LEFT JOIN communities ON csc_activities.activitable_type = 'Community' AND csc_activities.activitable_id = communities.id")
        .joins("LEFT JOIN sprint_goals AS skill_sg ON skills.sprint_goal_id = skill_sg.id")
        .joins("LEFT JOIN sprint_goals AS community_sg ON communities.sprint_goal_id = community_sg.id")
        .joins("LEFT JOIN sprint_goals AS direct_sg ON csc_activities.activitable_type = 'SprintGoal' AND csc_activities.activitable_id = direct_sg.id")
        .where("skill_sg.sprint_id = ? OR community_sg.sprint_id = ? OR direct_sg.sprint_id = ?", @sprint.id, @sprint.id, @sprint.id)
        .distinct
    else
      @csc_activities = activities_scope.where(hidden: false).order(created_at: :desc)
      @hidden_activities = activities_scope.where(hidden: true)
    end

    @show_all_sprints = params[:filter_sprint] == 'all'
  end

  def fetch_activities
    # Determine the learner (for LCs selecting a learner)
    if (current_user.role == 'lc' || current_user.role == 'admin') && params[:learner_id].present?
      @learner = User.find_by(id: params[:learner_id])
    else
      @learner = current_user
    end

    @csc_diploma = @learner.csc_diploma || @learner.create_csc_diploma

    # Find the last sprint goal for the user (only from past sprints)
    last_sprint_goal = @learner.sprint_goals
                               .includes(:skills, :communities)
                               .joins(:sprint)
                               .where('sprints.end_date >= ?', Date.current)
                               .order('sprints.end_date ASC')
                               .first

    if last_sprint_goal.nil?
      redirect_to csc_diploma_path(learner_id: @learner.id), alert: "No sprint goals found."
      return
    end

    created_count = 0

    # Create CSC activities from skills
    last_sprint_goal.skills.each do |skill|
      next if skill.csc_activity.present? # Skip if already has a CSC activity
      @csc_diploma.csc_activities.create(activitable: skill, full_name: @learner.full_name, date_of_submission: skill.sprint_goal.created_at, activity_name: skill.extracurricular, activity_type: "skill", start_date: skill.sprint_goal.sprint.start_date, end_date: skill.sprint_goal.sprint.end_date)
      created_count += 1
    end

    # Create CSC activities from communities
    last_sprint_goal.communities.each do |community|
      next if community.csc_activity.present? # Skip if already has a CSC activity

      @csc_diploma.csc_activities.create(activitable: community, full_name: @learner.full_name, date_of_submission: community.sprint_goal.created_at, activity_name: community.involved, activity_type: "community", start_date: community.sprint_goal.sprint.start_date, end_date: community.sprint_goal.sprint.end_date)
      created_count += 1
    end

    if created_count > 0
      redirect_to csc_diploma_path(learner_id: @learner.id), notice: "Successfully added #{created_count} activities from #{last_sprint_goal.sprint.name} #{last_sprint_goal.sprint.start_date.year}."
    else
      redirect_to csc_diploma_path(learner_id: @learner.id), notice: "No new activities to add. All activities from #{last_sprint_goal.sprint.name} #{last_sprint_goal.sprint.start_date.year} are already in your diploma."
    end
  end

  private

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end
end
