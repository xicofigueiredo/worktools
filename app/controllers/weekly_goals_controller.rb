class WeeklyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_subject_names
  before_action :set_topic_names
  before_action :set_available_weeks, only: [:new, :edit]

  def topics_for_subject
    # Assume subject_name is passed correctly and you find the subject by its name
    subject = Subject.find_by(name: params[:subject_name])

    if subject.present?
      # Fetch the topics based on the found subject's id
      topics = Topic.joins(:user_topics)
      .where(user_topics: { user_id: current_user.id, done: false })
      .where(subject_id: subject.id)
      .select(:id, :name)


      render json: topics
    else
      # If no subject is found, respond with an error message
      render json: { error: "Subject not found" }, status: :not_found
    end
  rescue => e
    # Log the error and respond with a generic 500 error message
    Rails.logger.error "Error in topics_for_subject: #{e.message}"
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end

  def index
    @weekly_goals = current_user.weekly_goals.order(created_at: :desc)
    @last_completed_weekly_goal = @weekly_goals.first
  end

  def show
    @subjects = @weekly_goal.weekly_slots&.pluck(:subject_name)&.uniq || []
    @topics = @weekly_goal.weekly_slots&.pluck(:topic_name)&.uniq || []
    @weekly_slots = @weekly_goal.weekly_slots
  end

  def new
    @weekly_goal = WeeklyGoal.new
    build_weekly_slots
  end

  def edit
    @weekly_goal = WeeklyGoal.find(params[:id])
    set_available_weeks(@weekly_goal.week_id)

    # Pre-populate or build missing slots if necessary
    WeeklySlot.time_slots.keys.each do |time|
      WeeklySlot.day_of_weeks.keys.each do |day|
        unless @weekly_goal.weekly_slots.any? { |slot| slot.day_of_week == day && slot.time_slot == time }
          @weekly_goal.weekly_slots.build(day_of_week: day, time_slot: time)
        end
      end
    end
  end

  def create
    @weekly_goal = current_user.weekly_goals.new(weekly_goal_params)

    if @weekly_goal.save
      save_weekly_slots
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully created.'
    else
      render :new
    end
  end

  def update
    if @weekly_goal.update(weekly_goal_params)
      save_weekly_slots
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @weekly_goal.destroy
    redirect_to weekly_goals_url, notice: 'Weekly goal was successfully destroyed.'
  end


  private

  def set_weekly_goal
    @weekly_goal = current_user.weekly_goals.find(params[:id])
  end

  def weekly_goal_params
    params.require(:weekly_goal).permit(:week_id, :start_date, :end_date, :user_id, :name, weekly_slots_attributes: [:id, :day_of_week, :time_slot, :subject_name, :topic_name])
  end

  def build_weekly_slots
    @weekly_slots = []
    WeeklySlot.time_slots.keys.each do |time_slot|
      WeeklySlot.day_of_weeks.keys.each do |day_of_week|
        @weekly_slots << @weekly_goal.weekly_slots.build(day_of_week: day_of_week, time_slot: time_slot)
      end
    end
  end

  def set_subject_names
    @subject_names = current_user.timelines.map(&:subject).uniq.pluck(:name)
  end

  def set_topic_names
    topics = Topic.joins(:user_topics)
                  .where(user_topics: { user_id: current_user.id, done: false })
                  .select('topics.id, topics.name, user_topics.deadline')

    # Use 'map' to extract the name and 'uniq' to remove duplicates
    @topic_names = topics.map(&:name).uniq
  end

  def save_weekly_slots
    return unless params[:weekly_goal].present?

    WeeklySlot.day_of_weeks.keys.each do |day|
      WeeklySlot.time_slots.keys.each do |time|
        subject = params[:weekly_goal]["#{day.downcase}_#{time.downcase}_subject"]
        topic = params[:weekly_goal]["#{day.downcase}_#{time.downcase}_topic"]

        # If subject is not present, set it to an empty string
        subject ||= ""

        # Create weekly slot
        @weekly_goal.weekly_slots.create(day_of_week: day, time_slot: time, subject_name: subject, topic_name: topic)
      end
    end
  end

  def set_available_weeks(edit_week_id = nil)
    used_week_ids = current_user.weekly_goals.pluck(:week_id)
    current_sprint = nil
    Sprint.all.each do |sprint|
      if sprint.start_date <= Date.today && sprint.end_date >= Date.today
        current_sprint = sprint
        break
      end
    end

    # Exclude the edit_week_id from used_week_ids if provided
    used_week_ids.delete(edit_week_id) if edit_week_id.present?
    @available_weeks = Week.where(sprint_id: current_sprint.id).where.not(id: used_week_ids)
    # Ensure the current week is included if we're editing
    if edit_week_id.present? && !@available_weeks.exists?(edit_week_id)
      @available_weeks = Week.where(sprint_id: current_sprint.id).where.not(id: used_week_ids)
    end
  end

end
