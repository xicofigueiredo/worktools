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


    @holidays = current_user.holidays.or(Holiday.where(bga: true))
  end

  def new
    @timeline = Timeline.new
    set_exam_dates
    @subjects = Subject.all.order(:category, :name)
    @subjects_with_timeline_ids = current_user.timelines.map(&:subject_id)
  end

  def create
    @timeline = current_user.timelines.new(timeline_params)
    set_exam_dates


    if @timeline.save
      generate_topic_deadlines(@timeline)
      redirect_to root_path, notice: 'Timeline was successfully created.'
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
    params.require(:timeline).permit(:user_id, :subject_id, :start_date, :end_date, :total_time, :exam_date_id)
  end

  def generate_topic_deadlines(timeline)
    subject = timeline.subject
    user_topics = subject.topics.map do |topic|
      current_user.user_topics.find_or_initialize_by(topic: topic)
    end

    calculate_holidays_array
    working_days = calculate_working_days(timeline)

    distribute_deadlines(user_topics, working_days)
  end

  def calculate_holidays_array
    @holidays_array ||= current_user.holidays.flat_map { |holiday| (holiday.start_date..holiday.end_date).to_a }
  end

  def calculate_working_days(timeline)
    (timeline.start_date...timeline.end_date).to_a.reject do |date|
      @holidays_array.include?(date) || date.saturday? || date.sunday?
    end
  end

  def distribute_deadlines(user_topics, working_days)
    total_time = working_days.count
    index = 0

    user_topics.each do |user_topic|
      time_per_topic = (user_topic.calculate_percentage * total_time).round
      deadline_date = calculate_deadline_date(index, time_per_topic, working_days, total_time)
      user_topic.deadline = deadline_date
      user_topic.save if user_topic.changed?
      index += time_per_topic
    end
  end

  def calculate_deadline_date(index, time_per_topic, working_days, total_time)
    # Ensure index does not exceed the bounds of working days
    final_index = [index + time_per_topic, total_time - 1].min
    working_days[final_index] || working_days.last
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
        if timeline.lws_timeline != nil
          expected = (timeline.lws_timeline.blocks_per_day * (Date.today - timeline.start_date).to_f).to_i
          actual = current_user.user_topics.where(topic_id: topic.id, done: true).count
          balance = actual - expected

          completed_topics_count += 1 if user_topic.done
          progress += user_topic.percentage if user_topic.done
          expected_progress = (expected / total_topics)

        else
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

      end

      # Calculate progress as an integer percentage of completed topics
      progress = (progress.to_f * 100).round

      expected_progress_percentage = (expected_progress.to_f * 100).round

      # Update timeline with both balance and progress
      timeline.update(balance: balance, progress: progress, expected_progress: expected_progress_percentage)
    end
  end
end
