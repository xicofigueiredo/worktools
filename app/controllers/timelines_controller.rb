require 'utilities/timeframe'

class TimelinesController < ApplicationController
  include ProgressCalculations
  include WorkingDaysAndHolidays
  include GenerateTopicDeadlines

  before_action :authenticate_user!
  before_action :set_timeline, only: [:show, :edit, :update, :destroy]



  def index

    @timelines_with_names = current_user.timelines.where.not(personalized_name: nil)

    @timelines = current_user.timelines_sorted_by_balance
    @has_lws = false
    @total_blocks_per_day = 0
    @timelines.each do |timeline|
      unless timeline.personalized_name
        # generate_topic_deadlines(timeline) --- this is needed when holidays update/create
        if timeline.subject.category.include?("lws")
          timeframe = Timeframe.new(Date.today, timeline.end_date)
          remaining_days = calculate_working_days(timeframe)
          remaining_topics = calc_remaining_blocks(timeline)
          blocks_per_day = remaining_topics.to_f / remaining_days.count
          @total_blocks_per_day += blocks_per_day
          @has_lws = true
        end
        timeline.calculate_total_time
        timeline.save
      end
    end

    calculate_progress_and_balance(@timelines)

    if @timelines.count.positive?
      @total_progress = (@timelines.sum(&:progress).to_f / @timelines.count) / 100
    else
      @total_progress = 0
    end

    start_of_current_month = Date.today.beginning_of_month
    end_of_current_month = Date.today.end_of_month

    @monthly_goals = @timelines.map do |timeline|
      # Group topics by their deadlines within the current month
      topics_grouped_by_deadline = timeline.subject.topics.includes(:user_topics)
                                            .where(user_topics: { user_id: current_user.id })
                                            .select { |topic|
                                              user_topic = topic.user_topics.find { |ut| ut.user_id == current_user.id }
                                              user_topic && user_topic.deadline && user_topic.deadline >= start_of_current_month && user_topic.deadline <= end_of_current_month
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


    @holidays = current_user.holidays
  end

  def new
    @timeline = Timeline.new
    set_exam_dates
    @subjects = Subject.all.order(:category, :name).reject do |subject|
      subject.name.blank? || subject.name.match?(/^P\d/)
    end

    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
  end

  def create
    @timeline = current_user.timelines.new(timeline_params)
    set_exam_dates


    if @timeline.save
      generate_topic_deadlines(@timeline)
      @timeline.save
      redirect_to timelines_path, notice: 'Timeline was successfully created.'
    else
      render :new
    end
  end

  def edit
    @edit = true
    set_exam_dates
    @subjects = Subject.all.order(:category, :name)

  end

  def update
    if @timeline.update(timeline_params)
      set_exam_dates

      @timeline.save
      generate_topic_deadlines(@timeline)

      @timeline.save
      redirect_to timelines_path, notice: 'Timeline was successfully updated.'
    else
      render :edit
    end
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
    @timeline.subject_id = 666  # Ensure subject ID remains 666 even if not included in form

    if @timeline.save
      redirect_to timelines_path, notice: 'Personalized Timeline was successfully updated.'
    else
      render :personalized_edit
    end
  end

  private

  def set_exam_dates
    @exam_dates = ExamDate.where('date >= ?', Date.today).order(:date).map do |exam_date|
      result = if exam_date.date.month == 5 || exam_date.date.month == 6
                 exam_date.date.strftime("May/June %Y")
               elsif exam_date.date.month == 10 || exam_date.date.month == 11
                 exam_date.date.strftime("Oct/Nov %Y")
               else
                 exam_date.date.strftime("%B %Y")
               end
      [result, exam_date.id]
    end
  end

  def set_timeline
    @timeline = Timeline.find(params[:id])
  end

  def timeline_params
    params.require(:timeline).permit(:user_id, :subject_id, :start_date, :end_date, :total_time, :exam_date_id, :mock100, :mock50, :personalized_name)
  end


  # FIXME remove if everything is alright after merge
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
