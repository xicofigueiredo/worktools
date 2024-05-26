class SprintGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sprint_goal, only: [:update]
  before_action :set_sprint_deadlines, only: [:index, :new, :edit]

  # GET /sprint_goals
  def index
    @sprint_goals = current_user.sprint_goals.joins(:sprint).includes(:knowledges, :skills, :communities).order('sprints.start_date DESC')
    @all_sprints = Sprint.all
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)
    @all_sprints = Sprint.all
    calc_nav_dates(@sprint)

    if @sprint
      @sprint_goal = current_user.sprint_goals.find_by(sprint: @sprint)

    else
      @sprint_goal = nil
    end

    @has_prev_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @prev_date, @prev_date).present?
    @has_next_sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @next_date, @next_date).present?
    @edit = false

  end

  # GET /sprint_goals/new
  def new
    @is_edit = false
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", @date, @date)

    @sprint_goal = current_user.sprint_goals.find_or_create_by(sprint: @sprint) do |sg|
      sg.sprint = @sprint
    end

    # # Check if a sprint goal already exists for this sprint and user
    # existing_goal = @sprint.sprint_goals.find_by(user: current_user)
    # if existing_goal
    #   redirect_to edit_sprint_goal_path(existing_goal), notice: 'You already have a Sprint Goal for this period. You are being redirected to edit it.'
    #   return # Ensure that the action is halted here
    # end

    # Build associated knowledges for each timeline
    # current_user.timelines.each do |timeline|
    #   subject = ''
    #   timeline.subject.name != '' ? subject = timeline.subject.name : subject = timeline.personalized_name
    #   @sprint_goal.knowledges.build(
    #     subject_name: subject,
    #     exam_season: timeline.exam_date ? timeline.exam_date.date.strftime("%B %Y") : 'N/A',
    #     mock50: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock50: true))&.deadline || 'N/A',
    #     mock100: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock100: true))&.deadline || 'N/A'
    #   )
    # end
  end


  # GET /sprint_goals/1/edit
  def edit
    @is_edit = true
    @sprint_goal = current_user.sprint_goals.includes(:knowledges, :skills, :communities).find(params[:id])
    @knowledges_subject_names = @sprint_goal.knowledges.pluck(:subject_name)
    @number_of_timelines = current_user.timelines.count

    Rails.logger.debug @sprint_goal.knowledges.inspect  # Add this line to check what's loaded

    # If the @sprint_goal doesn't have associated knowledges for each timeline, you need to build them here
    # current_user.timelines.each do |timeline|
    #   @sprint_goal.knowledges.find_or_initialize_by(subject_name: timeline.subject.name)
    # end

    # if @sprint_goal.knowledges.empty?
    #   current_user.timelines.each do |timeline|
    #     @sprint_goal.knowledges.build(
    #       subject_name: timeline.subject.name,
    #       exam_season: timeline.exam_date ? timeline.exam_date.date.strftime("%B %Y") : 'N/A',
    #       mock50: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock50: true))&.deadline || 'N/A',
    #       mock100: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock100: true))&.deadline || 'N/A'
    #     )
    #   end
    # end
    # @sprint_goal.skills.build if @sprint_goal.skills.empty?
    # @sprint_goal.communities.build if @sprint_goal.communities.empty?
  end

  # POST /sprint_goals
  def create
    @sprint_goal = current_user.sprint_goals.new(sprint_goal_params)
    @sprint_goal.sprint = current_sprint

    if @sprint_goal.save
      redirect_to sprint_goals_path(date: @sprint_goal.sprint.start_date), notice: 'Sprint goal was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /sprint_goals/1
  def update
    clean_params = sprint_goal_params

    # filtrar communites vazias
    clean_params[:communities_attributes]&.each do |key, attributes|
      if attributes.keys == ["id"] || (attributes[:involved].blank? && attributes[:smartgoals].blank? && attributes[:difficulties].blank? && attributes[:plan].blank?)
        clean_params[:communities_attributes].delete(key)
      end
    end

    # filtrar skills vazias
    clean_params[:skills_attributes]&.each do |key, attributes|
      if attributes.keys == ["id"] || (attributes[:extracurricular].blank? && attributes[:smartgoals].blank? && attributes[:difficulties].blank? && attributes[:plan].blank?)
        clean_params[:skills_attributes].delete(key)
      end
    end

    # filtrar knodleges vazias
    clean_params[:knowledges_attributes]&.each do |key, attributes|
      if attributes.keys == ["id"] || (attributes[:subject_name].present? && attributes[:subject_name].blank?)
        clean_params[:knowledges_attributes].delete(key)
      end
    end

    if @sprint_goal.update(clean_params)
      render json: { status: "success", message: "Sprint Goal updated successfully" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sprint_goals/1
  def destroy
    @sprint_goal.destroy
    redirect_to sprint_goals_url, notice: 'sprint_goal was successfully destroyed.'
  end

  # app/controllers/sprint_goals_controller.rb
  def reset_associations
    @sprint_goal = current_user.sprint_goals.find(params[:id])
    @sprint_goal.knowledges.destroy_all
    redirect_to edit_sprint_goal_path(@sprint_goal), notice: 'All associated records have been reset.'
  end

  def bulk_destroy
    Community.where(id: params[:deleted_communities_ids]).destroy_all
    Skill.where(id: params[:deleted_skills_ids]).destroy_all
    Knowledge.where(id: params[:deleted_knowledges_ids]).destroy_all
    render json: { status: "success", message: "Communities, skills and knowledges successfully deleted" }
  end


  private

  def calc_nav_dates(current_sprint)
    @next_date = current_sprint.end_date + 30
    @prev_date = current_sprint.start_date - 30
  end

  # def ensure_sprint_goal_exists(date)
  #   @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", date, date)
  #   return if @sprint.nil?

  #   @sprint_goal = current_user.sprint_goals.find_or_create_by(sprint: @sprint) do |sg|
  #     sg.sprint = @sprint
  #   end
  # end

  # def ensure_sprint_goal_exists(date)
  #   # Find the sprint that contains the given date
  #   @sprint = Sprint.find_by("start_date <= ? AND end_date >= ?", date, date)
  #   return if @sprint.nil?

  #   # Find or create a sprint goal for this sprint
  #   @sprint_goal = current_user.sprint_goals.find_or_create_by(sprint: @sprint) do |sg|
  #     sg.sprint = @sprint

  #     # Build associated knowledges records for each timeline
  #     current_user.timelines.each do |timeline|
  #       sg.knowledges.build(
  #         subject_name: timeline.subject.name,
  #         exam_season: timeline.exam_date ? timeline.exam_date.date.strftime("%B %Y") : 'N/A',
  #         mock50: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock50: true))&.deadline || 'N/A',
  #         mock100: current_user.user_topics.find_by(topic: timeline.subject.topics.find_by(Mock100: true))&.deadline || 'N/A'
  #       )
  #     end
  #   end
  # end



  def set_sprint_goal
    @sprint_goal = SprintGoal.find(params[:id])
  end

  def sprint_goal_params
    params.require(:sprint_goal).permit(:name, :start_date, :end_date, :sprint_id,
                                        knowledges_attributes: [:id, :difficulties, :plan, :_destroy, :subject_name, :mock50, :mock100, :exam_season],
                                        skills_attributes: [:id, :extracurricular, :smartgoals, :difficulties, :plan, :_destroy],
                                        communities_attributes: [:id, :involved, :smartgoals, :difficulties, :plan, :_destroy])
  end

  def current_sprint
    # This method should return the current sprint based on logic you define
    # For example, finding a sprint that includes today's date:
    Sprint.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)
  end

  def set_sprint_deadlines
    @sprint_deadlines = current_user.timelines.map do |timeline|
      # Group topics by their deadlines within the current sprint
      topics_grouped_by_deadline = timeline.subject.topics.includes(:user_topics)
                                            .where(user_topics: { user_id: current_user.id })
                                            .select { |topic|
                                              user_topic = topic.user_topics.find { |ut| ut.user_id == current_user.id }
                                              user_topic && user_topic.deadline && user_topic.deadline >= current_sprint.start_date && user_topic.deadline <= current_sprint.end_date
                                            }
                                            .group_by { |topic|
                                              topic.user_topics.find { |ut| ut.user_id == current_user.id }.deadline
                                            }

      # Find the latest deadline
      latest_deadline = topics_grouped_by_deadline.keys.max

      # Select the last topic with the latest deadline
      last_relevant_topic = topics_grouped_by_deadline[latest_deadline]&.last

      { timeline: timeline, topic: last_relevant_topic } if last_relevant_topic.present?
    end.compact
  end

end
