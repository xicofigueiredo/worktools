class WeeklyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_subject_names
  before_action :set_topic_names

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
    initialize_weekly_slots
  end

  def create
    @weekly_goal = current_user.weekly_goals.new(weekly_goal_params)

    if @weekly_goal.save
      save_weekly_slots
      redirect_to @weekly_goal, notice: 'Weekly goal was successfully created.'
      raise
    else
      initialize_weekly_slots
      render :new
    end
  end

  def update
    if @weekly_goal.update(weekly_goal_params)
      redirect_to @weekly_goals, notice: 'Weekly goal was successfully updated.'
    else
      initialize_weekly_slots
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
    params.require(:weekly_goal).permit(:start_date, :end_date, :user_id, :name, weekly_slots_attributes: [:id, :day_of_week, :time_slot, :subject_name, :topic_name])
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
    @topic_names = current_user.timelines.map(&:subject).map(&:topics).flatten.uniq.pluck(:name)
  end

  def save_weekly_slots
    return unless params[:weekly_goal][:weekly_slots_attributes].present?

    params[:weekly_goal][:weekly_slots_attributes].each do |_index, attributes|
      @weekly_goal.weekly_slots.create(attributes)
    end
  end

  def subject_for_slot(day, time)
    @weekly_goal.weekly_slots.find_by(day_of_week: day, time_slot: time)&.subject_name
  end

  def topic_for_slot(day, time)
    @weekly_goal.weekly_slots.find_by(day_of_week: day, time_slot: time)&.topic_name
  end

  def last_weekly_subject_for_slot(day, time)
    @last_completed_weekly_goal&.weekly_slots&.find_by(day_of_week: day, time_slot: time)&.subject_name
  end

  helper_method :subject_for_slot
  helper_method :topic_for_slot
  helper_method :last_weekly_subject_for_slot
end
