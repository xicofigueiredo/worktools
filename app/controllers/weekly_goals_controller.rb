class WeeklyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_goal, only: %i[show edit update destroy]
  before_action :set_subject_names, only: %i[new edit]
  before_action :set_topic_names, only: %i[new edit]

  def index
    @weekly_goals = current_user.weekly_goals.order(created_at: :desc)
    @last_completed_weekly_goal = @weekly_goals.first
  end

  def navigator
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.today

    @user_goals = current_user.weekly_goals
    @weekly_goal = current_user.weekly_goals.joins(:week).find_by("weeks.start_date <= ? AND weeks.end_date >= ?",
                                                                  @current_date, @current_date)
    @weekly_slots = @weekly_goal&.weekly_slots
    @current_week = Week.find_by("weeks.start_date <= ? AND weeks.end_date >= ?", @current_date, @current_date)
    @timelines = current_user.timelines

    @subjects = []

    @timelines.each do |timeline|
      subject = Subject.find_by("id = ?", timeline.subject_id)
      @subjects.append(subject)
    end
  end

  def color_picker
    @timelines = current_user.timelines.where(hidden: false)
    @date = params[:date]
  end

  def show
    @subjects = @weekly_goal.weekly_slots&.pluck(:subject_name)&.uniq || []
    @topics = @weekly_goal.weekly_slots&.pluck(:topic_name)&.uniq || []
    @weekly_slots = @weekly_goal.weekly_slots
  end

  def new
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @current_week = Week.where("start_date <= ? AND end_date >= ?", @date, @date).first
    @weekly_goal = current_user.weekly_goals.build(week: @current_week)
    @is_edit = false
    @special_subjects = @combined_options - @subject_names
    build_weekly_slots
  end

  def edit
    @weekly_goal = WeeklyGoal.find(params[:id])
    @is_edit = true
    @special_subjects = @combined_options - @subject_names
    # Pre-populate or build missing slots if necessary
    WeeklySlot.time_slots.each_key do |time|
      WeeklySlot.day_of_weeks.each_key do |day|
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
      redirect_to weekly_goals_navigator_path(date: @weekly_goal.week.start_date),
                  notice: 'Weekly goal was successfully created.'
    else
      render :new
    end
  end

  def update
    if @weekly_goal.update(weekly_goal_params)
      Rails.logger.debug "Updated Weekly Goal Week Start Date: #{@weekly_goal.week.start_date}"
      save_weekly_slots
      redirect_to weekly_goals_navigator_path(@weekly_goal.week.start_date),
                  notice: 'Weekly goal was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @weekly_goal.destroy
    redirect_to weekly_goals_url, notice: 'Weekly goal was successfully destroyed.'
  end

  def topics_for_subject
    # Assume subject_name is passed correctly and you find the subject by its name
    subject = Subject.find_by(name: params[:subject_name])

    if subject.present?
      # Fetch the topics based on the found subject's id
      topics = Topic.joins(:subject)
                    .joins(:user_topics)
                    .where(user_topics: { user_id: current_user.id })
                    .where(subject_id: subject.id)
                    .where("user_topics.done = ? OR user_topics.done IS NULL", false)
                    .select(:id, :name)
                    .order(:order)

      render json: topics
    else
      # If no subject is found, respond with an error message
      render json: { error: "Subject not found" }, status: :not_found
    end
  rescue StandardError => e
    # Log the error and respond with a generic 500 error message
    Rails.logger.error "Error in topics_for_subject: #{e.message}"
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end

  private

  # def ensure_weekly_goal_exists
  #   @date = params[:date] ? Date.parse(params[:date]) : Date.today
  #   @current_week = Week.find_by("start_date <= ? AND end_date >= ?", @date, @date)
  #   return if @current_week.nil?

  #   @weekly_goal = current_user.weekly_goals.find_or_create_by(week: @current_week) do |wg|
  #     wg.week = @current_week
  #     build_weekly_slots(wg)
  #   end
  # end

  def set_weekly_goal
    @weekly_goal = current_user.weekly_goals.find(params[:id])
  end

  def weekly_goal_params
    params.require(:weekly_goal).permit(:week_id, :start_date, :end_date, :user_id, :name, :subject_skill,
                                        weekly_slots_attributes: %i[id day_of_week time_slot subject_name topic_name custom_topic])
  end

  def set_subject_names
    @subject_names = current_user.timelines.where(hidden: false).map(&:subject).uniq.pluck(:name)
    personalized_names = current_user.timelines.where(subject_id: 666, hidden: false).map(&:personalized_name)
    current_sprint = Sprint.where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first
    skill_names = current_sprint.sprint_goals.where(user: current_user).map(&:skills).flatten.uniq.pluck(:extracurricular).reject(&:blank?).map(&:capitalize)
    communities_names = current_sprint.sprint_goals.where(user: current_user).map(&:communities).flatten.uniq.pluck(:involved).reject(&:blank?).map(&:capitalize)

    # Combine subjects and skills, prefixing each for clarity
    @combined_options = @subject_names.reject { |name| name == '' } +
                        skill_names.map { |name| name } +
                        communities_names.map { |name| name } +
                        personalized_names +
                        ["Other"]
  end

  def set_topic_names
    topics = Topic.joins(:subject)
                  .joins(:user_topics)
                  .where(user_topics: { user_id: current_user.id })
                  .where("user_topics.done = ? OR user_topics.done IS NULL", false)
                  .select('topics.id, topics.name, topics.unit, subjects.category as subject_category')
                  .order(:order)
    topic_names = topics.map do |topic|
      if topic.subject_category == 'lws'
        "#{topic.unit} - #{topic.name}"
      else
        topic.name
      end
    end.uniq
    @topic_names = ["Other"] + topic_names
  end

  def build_weekly_slots
    WeeklySlot.day_of_weeks.each_key do |day_of_week|
      WeeklySlot.time_slots.each_key do |time_slot|
        unless @weekly_goal.weekly_slots.exists?(day_of_week:, time_slot:)
          @weekly_goal.weekly_slots.build(day_of_week:, time_slot:)
        end
      end
    end
  end

  def save_weekly_slots
    return unless params[:weekly_goal].present?

    WeeklySlot.day_of_weeks.each_key do |day|
      WeeklySlot.time_slots.each_key do |time|
        # Build keys for subject and topic
        subject_key = "#{day.downcase}_#{time.downcase}_subject"
        topic_key = "#{day.downcase}_#{time.downcase}_topic"
        other_topic_key = "#{day.downcase}_#{time.downcase}_other_topic"
        custom_topic_key = "#{day.downcase}_#{time.downcase}_custom_topic"

        # Find existing slot or initialize a new one
        slot = @weekly_goal.weekly_slots.find_or_initialize_by(day_of_week: day, time_slot: time)

        # Assign new values from parameters
        slot.subject_name = params[:weekly_goal][subject_key].presence || ""
        slot.topic_name = params[:weekly_goal][other_topic_key].presence || params[:weekly_goal][topic_key].presence || ""
        slot.custom_topic = params[:weekly_goal][custom_topic_key].presence || ""

        # Check if the slot is new or has changes and save it
        slot.save if slot.new_record? || slot.changed?
      end
    end
  end

  def dynamic_slot_params
    allowed_params = []
    WeeklySlot.day_of_weeks.each_key do |day|
      WeeklySlot.time_slots.each_key do |time|
        allowed_params << "#{day.downcase}_#{time.downcase}_subject"
        allowed_params << "#{day.downcase}_#{time.downcase}_topic"
      end
    end
    allowed_params
  end
end
