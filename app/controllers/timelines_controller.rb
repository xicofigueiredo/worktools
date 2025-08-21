require 'utilities/timeframe'

class TimelinesController < ApplicationController
  include ProgressCalculations
  include WorkingDaysAndHolidays
  include GenerateTopicDeadlines

  before_action :authenticate_user!
  before_action :set_timeline, only: %i[show edit update destroy archive]

  def index
    @learner = current_user
    @archived = @learner.timelines.exists?(hidden: true)

    weekly_percentages = []

    @timelines = @learner.timelines_sorted_by_balance
                             .where(hidden: false)
                             .includes(subject: :topics)

    @average_weekly_percentage = calc_array_average(weekly_percentages).round(1)
    calculate_progress_and_balance(@timelines)
    # @monthly_goals = calculate_monthly_goals(@timelines)

    @holidays = @learner.holidays.where("end_date >= ?", 4.months.ago)

    @has_exam_date  = @timelines.any? { |timeline| timeline.exam_date_id.present? }
    @has_timeline = @learner.timelines.where(hidden: false).any?
  end

  def moodle_index
      @learner = current_user
      @archived = @learner.timelines.exists?(hidden: true)
      # Eager load the subject and its topics (avoid unnecessary eager loading)
      @timelines = @learner.timelines_sorted_by_balance
                             .where(hidden: false)

      moodle_calculate_progress_and_balance(@timelines)

      @holidays = @learner.holidays.where("end_date >= ?", 4.months.ago)

      @has_exam_date  = @timelines.any? { |timeline| timeline.exam_date_id.present? }
      @has_timeline = @learner.timelines.where(hidden: false).any?

  end

  def show
    @timeline = Timeline.find(params[:id])
    @learner = User.find(params[:learner_id]) if params[:learner_id].present?
    render partial: "timeline_detail", locals: { timeline: @timeline }, layout: false
  end

  def moodle_show
    @timeline = Timeline.find(params[:id])
    @learner = User.find(params[:learner_id]) if params[:learner_id].present?
    render partial: "moodle_timeline_detail", locals: { timeline: @timeline }, layout: false
  end

  def new
    @timeline = Timeline.new
    set_exam_dates(filter_future: true) # Only include future dates for new
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.name.blank? || subject.name.match?(/^P\d/) || subject.id == 101 || subject.id == 356 || subject.id == 578 || subject.id == 105 || subject.id == 575 || subject.id == 89
    end
    @max_date = Date.today + 5.years
    @min_date = Date.today - 5.years
    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
  end

  def create
    @timeline = current_user.timelines.new(timeline_params)

    if @timeline.save
      # if current_user.hub_ids.include?(147)
      if false
        moodle_generate_topic_deadlines(@timeline)
      else
        generate_topic_deadlines(@timeline)
      end
      @timeline.save
      redirect_to timelines_path, notice: 'Timeline was successfully created.'
    else
      flash.now[:alert] = @timeline.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @learner = @timeline.user
    @edit = true
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.name.blank? || subject.name.match?(/^P\d/) || subject.id == 101 || subject.id == 578 || subject.id == 105 || subject.id == 575
    end
    @max_date = Date.today + 5.year
    @min_date = Date.today - 5.year
    @subjects_with_timeline_ids = @learner.timelines.map(&:subject_id)
    @selected_exam_date_id = @timeline.exam_date_id
    @exam_dates_edit = ExamDate.where(subject_id: @timeline.subject_id).order(:date)
  end

  def update
    @learner = @timeline.user

    ## i want to add a method that if i add a topic on dbeaver, it will automatically add the user_topic to all the users after update timeline
    if @timeline.update(timeline_params)

      @timeline.save
      # if current_user.hub_ids.include?(147)
      if false
        moodle_generate_topic_deadlines(@timeline)
      else
        generate_topic_deadlines(@timeline)
      end

      @timeline.save

      if current_user.role != @learner.role
        redirect_to learner_profile_path(@timeline.user_id)
      else
        redirect_to timelines_path, notice: 'Timeline was successfully updated.'
      end

    else
      @edit = true
      @subjects = Subject.order(:category, :name)
      @max_date = Date.today + 5.year
      @min_date = Date.today - 5.year
      @subjects_with_timeline_ids = @learner.timelines.map(&:subject_id)
      @selected_exam_date_id = @timeline.exam_date_id
      @exam_dates_edit = ExamDate.where(subject_id: @timeline.subject_id).order(:date)
      flash.now[:alert] = @timeline.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_colors
    params[:timelines].each do |id, timeline_params|
      timeline = Timeline.find(id)
      timeline.update(timeline_params.permit(:color))
    end
    redirect_to weekly_goals_navigator_path(date: params[:date]), notice: "Colors updated successfully!"
  end

  def destroy
    @timeline.destroy
    redirect_to timelines_url, notice: 'Timeline was successfully destroyed.'
  end

  def personalized_new
    @timeline = Timeline.new
    set_exam_dates
  end

  def personalized_create
    @timeline = current_user.timelines.new(timeline_params)
    @timeline.subject_id = 666

    if @timeline.save
      redirect_to timelines_path, notice: 'Personalized Timeline was successfully created.'
    else
      render :personalized_new
    end
  end

  def personalized_edit
    @timeline = Timeline.find(params[:id])
  end

  def personalized_update
    @timeline = Timeline.find(params[:id])
    @timeline.assign_attributes(timeline_params)
    @timeline.subject_id = 666 # Ensure subject ID remains 666 even if not included in form

    if @timeline.save
      redirect_to timelines_path, notice: 'Personalized Timeline was successfully updated.'
    else
      render :personalized_edit
    end
  end

  def archive
    @timeline = Timeline.find(params[:id])
    if @timeline.update(hidden: true)
      redirect_to timelines_path, notice: "Timeline successfully archived."
    else
      redirect_to timelines_path, alert: "Failed to archive the timeline."
    end
  end

  def toggle_archive
    @timeline = Timeline.find(params[:id])
    new_state = !@timeline.hidden

    if @timeline.update(hidden: new_state)
      message = new_state ? "Timeline successfully archived." : "Timeline successfully reactivated."
      redirect_to timelines_path, notice: message
    else
      redirect_to timelines_path, alert: "Failed to toggle the state of the timeline."
    end
  end

  def archived
    @learner = current_user
    @archived_timelines = Timeline.where(user: @learner, hidden: true)
                                  .includes(subject: :topics)
    @past_holidays = @learner.holidays.where("end_date <= ?", Date.today)

    # Preload all topic IDs from the archived timelines' subjects
    all_topic_ids = @archived_timelines.flat_map { |t| t.subject.topics.pluck(:id) }.uniq
    @user_topics_by_topic = @learner.user_topics.where(topic_id: all_topic_ids).index_by(&:topic_id)
  end

  private

  def set_timeline
    @timeline = Timeline.find(params[:id])
  end

  def timeline_params
    params.require(:timeline).permit(:user_id, :subject_id, :start_date, :end_date, :total_time, :exam_date_id,
                                     :mock100, :mock50, :personalized_name, :hidden)
  end

  # def calculate_monthly_goals(timelines)
  #   Rails.cache.fetch("monthly_goals_#{Date.today.beginning_of_month}", expires_in: 1.month) do
  #     timelines.filter_map do |timeline|
  #       topics_grouped_by_deadline = timeline.subject.topics.includes(:user_topics)
  #                                            .where(user_topics: { user_id: current_user.id })
  #                                            .select do |topic|
  #         user_topic = topic.user_topics.find do |ut|
  #           ut.user_id == current_user.id
  #         end
  #         user_topic && user_topic.deadline &&
  #           user_topic.deadline >= Date.today.beginning_of_month &&
  #           user_topic.deadline <= Date.today.end_of_month
  #       end
  #         .group_by { |topic| topic.user_topics.find { |ut| ut.user_id == current_user.id }.deadline }

  #       latest_deadline = topics_grouped_by_deadline.keys.max
  #       last_relevant_topic = topics_grouped_by_deadline[latest_deadline]&.last

  #       { timeline:, topic: last_relevant_topic } if last_relevant_topic.present?
  #     end.compact
  #   end
  # end


  def set_exam_dates(filter_future: false)
    scope = filter_future ? ExamDate.where("date >= ?", Date.today) : ExamDate.all
    @exam_dates = scope.includes(:subject).map do |exam_date|
      { id: exam_date.id, name: exam_date.formatted_date, subject_id: exam_date.subject_id }
    end
  end



  # FIXME: remove if everything is alright after merge
  # def calculate_holidays_array
  #   user_holidays ||= current_user.holidays.flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
  #   bga_holidays ||= Holiday.where(bga: true).flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
  #   hub_holidays ||= Holiday.where(country: current_user.users_hubs.find_by(main: true)&.hub.country).flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }

  #   @holidays_array = (user_holidays + bga_holidays + hub_holidays).uniq
  # end

  # def calculate_working_days(timeline)
  #   (timeline.start_date..timeline.end_date).to_a.reject do |date|
  #     @holidays_array.include?(date) || date.saturday? || date.sunday?
  #   end
  # end

  # def calc_remaining_working_days(timeline)
  #   date = [Date.today, timeline.start_date].max
  #   (date..timeline.end_date).to_a.reject do |date|
  #     @holidays_array.include?(date) || date.saturday? || date.sunday?
  #   end.count
  # end
end
