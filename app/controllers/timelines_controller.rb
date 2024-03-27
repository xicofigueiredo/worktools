class TimelinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_timeline, only: [:show, :edit, :update, :destroy]


  def index

    if current_user.role == "lc"
      redirect_to dashboard_lc_path
    end

    @timelines = current_user.timelines_sorted_by_balance
    @timelines.each do |timeline|
      timeline.calculate_total_time
      generate_topic_deadlines(timeline)
      timeline.save
    end
    calculate_progress_and_balance

    if @timelines.count.positive?
      @total_progress = (@timelines.sum(&:progress).to_f / @timelines.count) / 100
    else
      @total_progress = 0
    end

    start_of_current_month = Date.today.beginning_of_month
    end_of_current_month = Date.today.end_of_month

    @monthly_goals = @timelines.map do |timeline|
      last_relevant_topic = timeline.subject.topics.includes(:user_topics)
                                    .where(user_topics: { user_id: current_user.id })
                                    .select { |topic|
                                      user_topic = topic.user_topics.find { |ut| ut.user_id == current_user.id }
                                      user_topic && user_topic.deadline && user_topic.deadline >= start_of_current_month && user_topic.deadline <= end_of_current_month
                                    }
                                    .max_by { |topic|
                                      topic.user_topics.find { |ut| ut.user_id == current_user.id }.deadline
                                    }
      { timeline: timeline, topic: last_relevant_topic } if last_relevant_topic.present?
    end.compact

    @holidays = current_user.holidays.or(Holiday.where(bga: true))
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
        render :new, status: :unprocessable_entity
        return
      end
    when :may_jun
      if @timeline.end_date.month > 2
        @timeline.errors.add(:end_date, "cannot be after 28/29 February for May/June season")
        render :new, status: :unprocessable_entity
        return
      end
    when :oct_nov
      if @timeline.end_date.month > 7
        @timeline.errors.add(:end_date, "cannot be after 31 July for October/November season")
        render :new, status: :unprocessable_entity
        return
      end
    end



    if @timeline.save
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
      if index > total_time - 0.5
        deadline_date = timeline.end_date
      end
      user_topic.deadline = deadline_date
      user_topic.save
    end
  end

  def calculate_progress_and_balance
    @timelines.each do |timeline|
      balance = 0
      completed_topics_count = 0 # Count of completed topics for progress calculation
      progress = 0
      expected_progress = 0

      topics = timeline.subject.topics
      total_topics = topics.count

      topics.each do |topic|
        user_topic = current_user.user_topics.find_by(topic_id: topic.id)
        next unless user_topic # Skip if no user_topic found

        # Balance calculation
        if user_topic.done && user_topic.deadline >= Date.today
          balance += 1
        elsif !user_topic.done && user_topic.deadline < Date.today
          balance -= 1
        end

        # Counting completed topics for progress calculation
        completed_topics_count += 1 if user_topic.done
        progress += user_topic.percentage if user_topic.done
        expected_progress += user_topic.percentage if user_topic.deadline < Date.today
      end

      # Calculate progress as an integer percentage of completed topics
      progress = (progress.to_f * 100).round

      expected_progress_percentage = (expected_progress.to_f * 100).round

      # Update timeline with both balance and progress
      timeline.update(balance: balance, progress: progress, expected_progress: expected_progress_percentage)
    end
  end



end
