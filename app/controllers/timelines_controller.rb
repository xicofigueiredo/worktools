class TimelinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_timeline, only: [:show, :edit, :update, :destroy]


  def index
    @timelines = current_user.timelines.sort_by { |timeline| timeline.balance }
    @timelines.each do |timeline|
      timeline.calculate_total_time
      generate_topic_deadlines(timeline)
      calculate_progress(timeline)
      calculate_balance(timeline)
      timeline.save
    end

    @holidays = current_user.holidays
  end

  def new
    @timeline = Timeline.new
    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
  end

  def create
    @timeline = current_user.timelines.new(timeline_params)

    case @timeline.exam_season.to_sym
    when :jan
      if @timeline.end_date.month > 10
        @timeline.errors.add(:end_date, "cannot be after 31 November for January season")
        render :new
        return
      end
    when :may_jun
      if @timeline.end_date.month > 2
        @timeline.errors.add(:end_date, "cannot be after 28/29 February for May/June season")
        render :new
        return
      end
    when :oct_nov
      if @timeline.end_date.month > 7
        @timeline.errors.add(:end_date, "cannot be after 31 July for October/November season")
        render :new
        return
      end
    end



    if @timeline.save
      @timeline.subject.topics.each do |topic|
        user_topic = UserTopic.create(user_id: current_user.id, topic_id: topic.id)
        user_topic.save
      end
      generate_topic_deadlines(@timeline)
      redirect_to root_path, notice: 'Timeline was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @timeline.update(timeline_params)
      @timeline.save
      generate_topic_deadlines(@timeline)
      redirect_to root_path, notice: 'Timeline was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @timeline.destroy
    redirect_to timelines_url, notice: 'Timeline was successfully destroyed.'
  end

  private

  def set_timeline
    @timeline = Timeline.find(params[:id])
  end

  def timeline_params
    params.require(:timeline).permit(:user_id, :subject_id, :start_date, :end_date, :total_time, :exam_season)
  end

  def generate_topic_deadlines(timeline)
    subject = timeline.subject

    user_topics = []
    subject.topics.each do |topic|
      user_topic = current_user.user_topics.find_by(topic_id: topic.id)
      user_topics << user_topic
    end

    @holidays_array = []
    current_user.holidays.each do |holiday|
      @holidays_array = @holidays_array + (holiday.start_date..holiday.end_date).to_a
    end

    timeline_array = (timeline.start_date...timeline.end_date).to_a
    working_days = timeline_array.reject { |date| @holidays_array.include?(date) || date.saturday? || date.sunday?}

    total_time = working_days.count

    index = 0
    user_topics.each_with_index do |user_topic, i|
      time_per_topic = (user_topic.calculate_percentage * total_time)
      index += time_per_topic
      deadline_date = working_days[index]
      if index > working_days.count - 0.5
        deadline_date = timeline.end_date
      end
      user_topic.deadline = deadline_date
      user_topic.save
    end
  end

  def calculate_progress(timeline)
    @progress = 0
    @timelines.each do |timeline|
      timeline.user.user_topics.each do |user_topic|
        if user_topic.done
          @progress += user_topic.percentage
        end
      end
    end
    @progress = (@progress * 100 + 17).round
  end

  def calculate_balance(timeline)
    @timelines.each do |timeline|
      balance = 0
      timeline.subject.topics.each do |topic|
        user_topic = current_user.user_topics.find_by(topic_id: topic.id)
        if user_topic.done && user_topic.deadline > Date.today
          balance += 1
        elsif (user_topic.done == nil || user_topic.done) && user_topic.deadline < Date.today
          balance -= 1
        else
          balance += 0
        end
        timeline.balance = balance
      end
      timeline.save
    end
  end
end
