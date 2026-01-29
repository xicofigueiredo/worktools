class CscDiplomasController < ApplicationController
  before_action :authenticate_user!

  def show
    @csc_diploma = current_user.csc_diplomas.where(issued: false).first || current_user.create_csc_diploma
    @csc_activities = @csc_diploma.csc_activities.where(hidden: false)
                                  .includes(activitable: { sprint_goal: :sprint }).order(created_at: :desc)
    @hidden_activities = @csc_diploma.csc_activities.where(hidden: true)
                                     .includes(activitable: { sprint_goal: :sprint })
  end

  def fetch_activities
    @csc_diploma = current_user.csc_diplomas.where(issued: false).first || current_user.create_csc_diploma

    # Find the last sprint goal for the user (only from past sprints)
    last_sprint_goal = current_user.sprint_goals
                                   .includes(:skills, :communities)
                                   .joins(:sprint)
                                   .where('sprints.end_date >= ?', Date.current)
                                   .order('sprints.end_date ASC')
                                   .first


    if last_sprint_goal.nil?
      redirect_to csc_diploma_path, alert: "No sprint goals found."
      return
    end

    created_count = 0

    # Create CSC activities from skills
    last_sprint_goal.skills.each do |skill|
      next if skill.csc_activity.present? # Skip if already has a CSC activity
      @csc_diploma.csc_activities.create(activitable: skill, full_name: current_user.full_name, date_of_submission: skill.sprint_goal.created_at, activity_name: skill.extracurricular, activity_type: "skill", start_date: skill.sprint_goal.sprint.start_date, end_date: skill.sprint_goal.sprint.end_date)
      created_count += 1
    end

    # Create CSC activities from communities
    last_sprint_goal.communities.each do |community|
      next if community.csc_activity.present? # Skip if already has a CSC activity

      @csc_diploma.csc_activities.create(activitable: community, full_name: current_user.full_name, date_of_submission: community.sprint_goal.created_at, activity_name: community.involved, activity_type: "community", start_date: community.sprint_goal.sprint.start_date, end_date: community.sprint_goal.sprint.end_date)
      created_count += 1
    end

    if created_count > 0
      redirect_to csc_diploma_path, notice: "Successfully added #{created_count} activities from #{last_sprint_goal.sprint.name} #{last_sprint_goal.sprint.start_date.year}."
    else
      redirect_to csc_diploma_path, notice: "No new activities to add. All activities from #{last_sprint_goal.sprint.name} #{last_sprint_goal.sprint.start_date.year} are already in your diploma."
    end
  end
end
