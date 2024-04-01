class WeeklyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_available_weeks, only: [:new, :edit, :create, :update]


  def index
    @weekly_goals = current_user.weekly_goals.order(created_at: :desc)
    @last_completed_weekly_goal = @weekly_goals.first
  end

  def show
    @subjects = @weekly_goal.weekly_slots.includes(:subject).map(&:subject).map(&:name).uniq
    @topics = @weekly_goal.weekly_slots.includes(:topic).map(&:topic).map(&:name).uniq
    @weekly_slots = @weekly_goal.weekly_slots
  end

  def new
    @weekly_goal = WeeklyGoal.new
    WeeklySlot.day_of_weeks.each_key do |day|
      WeeklySlot.time_slots.each_key do |time|
        @weekly_goal.weekly_slots.build(day_of_week: day, time_slot: time)
      end
    end
    @subjects = []
    current_user.timelines.each do |timeline|
      @subjects << timeline.subject
    end

    # Assuming Topic has_many :user_topics and UserTopic belongs_to :topic
    @topics = Topic.joins(:user_topics)
                            .where(user_topics: { user_id: current_user.id, done: false })
                            .order('user_topics.deadline ASC') # Order topics by their deadline
                            .select('topics.*, user_topics.deadline') # Select topics and their deadline
                            .distinct

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
    @subjects = []
    current_user.timelines.each do |timeline|
      @subjects << timeline.subject
    end

    # Assuming Topic has_many :user_topics and UserTopic belongs_to :topic
    @topics = Topic.joins(:user_topics)
                            .where(user_topics: { user_id: current_user.id, done: false })
                            .order('user_topics.deadline ASC') # Order topics by their deadline
                            .select('topics.*, user_topics.deadline') # Select topics and their deadline
                            .distinct

  end

  def create
    @subjects = Subject.all
    @weekly_goal = current_user.weekly_goals.new(weekly_goal_params)

    if @weekly_goal.save
      save_weekly_slots
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully created.'
    else
      initialize_weekly_slots
      render :new
    end
  end

  def update
    @subjects = Subject.all
    if @weekly_goal.update(weekly_goal_params)
      save_weekly_slots
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully updated.'
    else
      initialize_weekly_slots
      render :edit
    end
  end

  def destroy
    @weekly_goal.destroy
    redirect_to weekly_goals_url, notice: 'Weekly goal was successfully destroyed.'
  end

  def topics_for_subject
    subject = Subject.find_by(id: params[:subject_id])
    topics = subject ? subject.topics : []
    render json: topics
  end

  def show_calendar
    # Assuming `params[:start_date]` holds the week's start date; otherwise, default to the current week
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current.beginning_of_week
    end_date = start_date.end_of_week

    # Fetch meetings within the week. Adjust according to your application's logic.
    @meeting_slots = MeetingSlot.where('timeslot >= ? AND timeslot < ?', start_date, end_date)
  end

  private

  def topics
    @topics = Topic.where(subject_id: params[:id]).order(:name)
    render json: @topics
  end

  def set_weekly_goal
    @weekly_goal = current_user.weekly_goals.find(params[:id])
  end

  def weekly_goal_params
    params.require(:weekly_goal).permit(
      :start_date, :end_date, :user_id, :name,
      weekly_slots_attributes: [:id, :day_of_week, :time_slot, :subject_id, :topic_id, :_destroy])
  end


  def build_weekly_slots
    @weekly_slots = []
    WeeklySlot.time_slots.keys.each do |time_slot|
      WeeklySlot.day_of_weeks.keys.each do |day_of_week|
        @weekly_slots << @weekly_goal.weekly_slots.build(day_of_week: day_of_week, time_slot: time_slot)
      end
    end
  end

  def save_weekly_slots
    return unless params[:weekly_goal].present?

    WeeklySlot.day_of_weeks.keys.each do |day|
      WeeklySlot.time_slots.keys.each do |time|
        subject_id = params[:weekly_goal]["#{day.downcase}_#{time.downcase}_subject_id"]
        topic_id = params[:weekly_goal]["#{day.downcase}_#{time.downcase}_topic_id"]

        # Skip creation if subject_id or topic_id is not present
        next if subject_id.blank? || topic_id.blank?

        # Create weekly slot
        @weekly_goal.weekly_slots.create(day_of_week: day, time_slot: time, subject_id: subject_id, topic_id: topic_id)
      end
    end
  end


  def initialize_weekly_slots
    @weekly_slots = []
    WeeklySlot.time_slots.keys.each do |time_slot|
      WeeklySlot.day_of_weeks.keys.each do |day_of_week|
        @weekly_slots << @weekly_goal.weekly_slots.build(day_of_week: day_of_week, time_slot: time_slot)
      end
    end
    @weekly_slots.uniq!
    @weekly_slots.sort!
  end

  def set_available_weeks(edit_week_id = nil)
    used_week_ids = current_user.weekly_goals.pluck(:week_id)

    # Exclude the edit_week_id from used_week_ids if provided
    used_week_ids.delete(edit_week_id) if edit_week_id.present?

    @available_weeks = Week.where.not(id: used_week_ids)

    # Ensure the current week is included if we're editing
    if edit_week_id.present? && !@available_weeks.exists?(edit_week_id)
      @available_weeks = @available_weeks.or(Week.where(id: edit_week_id))
    end
  end

end
