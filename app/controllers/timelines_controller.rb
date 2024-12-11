require 'utilities/timeframe'

class TimelinesController < ApplicationController
  include ProgressCalculations
  include WorkingDaysAndHolidays
  include GenerateTopicDeadlines

  before_action :authenticate_user!
  before_action :set_timeline, only: %i[show edit update destroy archive]

  def index
    @archived = current_user.timelines.exists?(hidden: true)

    @has_lws = false
    @total_blocks_per_day = 0
    @total_hours_per_week = 0
    weekly_percentages = []
    timelines = current_user.timelines_sorted_by_balance.where(hidden: false)

    @average_weekly_percentage = calc_array_average(weekly_percentages).round(1)

    calculate_progress_and_balance(timelines)

    # @monthly_goals = calculate_monthly_goals(timelines)

    @holidays = current_user.holidays.where("end_date >= ?", 4.months.ago)

    @timelines = timelines.map do |timeline|
      {
        "id" => timeline.id,
        "subject_id" => timeline.subject_id,
        "subject_name" => timeline.subject.name,
        "personalized_name" => timeline.personalized_name,
        "category" => timeline.subject.category,
        "start_date" => timeline.start_date,
        "end_date" => timeline.end_date,
        "progress" => timeline.progress,
        "balance" => timeline.balance,
        "topics" => timeline.subject.topics.order(:order, id: :asc).map do |topic|
          user_topic = current_user.user_topics.find_or_initialize_by(topic:)
          {
            "id" => topic.id,
            "name" => topic.name,
            "unit" => topic.unit,
            "time" => topic.time,
            "deadline" => user_topic.deadline,
            "done" => user_topic.done,
            "user_topic_id" => user_topic.id
          }
        end
      }
    end
    #     timelines.each do |timeline|
    #       unless timeline.personalized_name
    #         if timeline.subject.category.include?("lws")
    #           timeframe = Timeframe.new(Date.today, timeline.end_date)
    #           remaining_days = calculate_working_days(timeframe)
    #           remaining_topics = calc_remaining_blocks(timeline)
    #           blocks_per_day = remaining_topics.to_f / remaining_days.count
    #           @total_blocks_per_day += blocks_per_day
    #           @has_lws = true
    #         else
    #           remaining_hours_count, remaining_percentage = calc_remaining_timeline_hours_and_percentage(timeline)
    #           remaining_weeks_count = Week.where("start_date >= ? AND end_date <= ?", Date.today, timeline.end_date)
    #           .where.not("name LIKE ?", "%Build Week%").count
    #
    #           @total_hours_per_week += remaining_weeks_count.zero? ? 0 : remaining_hours_count / remaining_weeks_count
    #
    #           weekly_percentage = remaining_weeks_count.zero? ? remaining_percentage * 100 : remaining_percentage / remaining_weeks_count * 100
    #
    #           weekly_percentages.push((weekly_percentage).round(2))
    #
    #
    #         end
    #         timeline.save
    #       end
    #
    #     end
    #     if timelines.count.positive?
    #       @total_progress = (timelines.sum(&:progress).to_f / timelines.count) / 100
    #     else
    #       @total_progress = 0
    #     end
  end

  def new
    @timeline = Timeline.new
    set_exam_dates(filter_future: true) # Only include future dates for new
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.name.blank? || subject.name.match?(/^P\d/) || subject.id == 101 || subject.id == 578 || subject.id == 105
    end
    @max_date = Date.today + 5.years
    @min_date = Date.today - 5.years
    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
  end

  def create
    @timeline = current_user.timelines.new(timeline_params)

    if @timeline.save
      generate_topic_deadlines(@timeline)
      @timeline.save
      redirect_to timelines_path, notice: 'Timeline was successfully created.'
    else
      flash.now[:alert] = @timeline.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @edit = true
    @subjects = Subject.order(:category, :name)
    @max_date = Date.today + 5.year
    @min_date = Date.today - 5.year
    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
    @selected_exam_date_id = @timeline.exam_date_id
    @exam_dates_edit = ExamDate.where(subject_id: @timeline.subject_id).order(:date)
  end

  def update
    ## i want to add a method that if i add a topic on dbeaver, it will automatically add the user_topic to all the users after update timeline
    if @timeline.update(timeline_params)

      @timeline.save
      generate_topic_deadlines(@timeline)

      @timeline.save
      redirect_to timelines_path, notice: 'Timeline was successfully updated.'

    else
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
    @archived_timelines = Timeline.where(user: current_user, hidden: true)
    @past_holidays = current_user.holidays.where("end_date <= ?", Date.today)
  end

  private

  def set_timeline
    @timeline = Timeline.find(params[:id])
  end

  def timeline_params
    params.require(:timeline).permit(:user_id, :subject_id, :start_date, :end_date, :total_time, :exam_date_id,
                                     :mock100, :mock50, :personalized_name)
  end

  def calculate_monthly_goals(timelines)
    Rails.cache.fetch("monthly_goals_#{Date.today.beginning_of_month}", expires_in: 1.month) do
      timelines.filter_map do |timeline|
        topics_grouped_by_deadline = timeline.subject.topics.includes(:user_topics)
                                             .where(user_topics: { user_id: current_user.id })
                                             .select do |topic|
          user_topic = topic.user_topics.find do |ut|
            ut.user_id == current_user.id
          end
          user_topic && user_topic.deadline &&
            user_topic.deadline >= Date.today.beginning_of_month &&
            user_topic.deadline <= Date.today.end_of_month
        end
          .group_by { |topic| topic.user_topics.find { |ut| ut.user_id == current_user.id }.deadline }

        latest_deadline = topics_grouped_by_deadline.keys.max
        last_relevant_topic = topics_grouped_by_deadline[latest_deadline]&.last

        { timeline:, topic: last_relevant_topic } if last_relevant_topic.present?
      end.compact
    end
  end


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
  #   hub_holidays ||= Holiday.where(country: current_user.users_hubs.first.hub.country).flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }

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
