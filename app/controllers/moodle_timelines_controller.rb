require 'utilities/timeframe'

class MoodleTimelinesController < ApplicationController
  include ProgressCalculations
  include WorkingDaysAndHolidays
  include GenerateTopicDeadlines

  before_action :authenticate_user!
  before_action :set_moodle_timeline, only: %i[show edit update destroy archive]

  def index
      @learner = current_user
      @archived = @learner.moodle_timelines.exists?(hidden: true)
      # Eager load the subject and its topics (avoid unnecessary eager loading)
      @moodle_timelines = @learner.moodle_timelines_sorted_by_balance
                             .where(hidden: false)
      moodle_calculate_progress_and_balance(@moodle_timelines)

      @holidays = @learner.holidays.where("end_date >= ?", 4.months.ago)

      @has_exam_date  = @moodle_timelines.any? { |moodle_timeline| moodle_timeline.exam_date_id.present? }
      @has_moodle_timeline = @learner.moodle_timelines.where(hidden: false).any?
  end

  def moodle_show
    @moodle_timeline = MoodleTimeline.find(params[:id])
    @learner = User.find(params[:learner_id]) if params[:learner_id].present?
    render partial: "moodle_timeline_detail", locals: { moodle_timeline: @moodle_timeline }, layout: false
  end

  def create
    @moodle_timeline = current_user.moodle_timelines.new(moodle_timeline_params)

    if @moodle_timeline.save
      # if current_user.hub_ids.include?(147)
      if false
        moodle_generate_topic_deadlines(@moodle_timeline)
      else
        generate_topic_deadlines(@moodle_timeline)
      end
      @moodle_timeline.save
      redirect_to moodle_timelines_path, notice: 'Moodle Timeline was successfully created.'
    else
      flash.now[:alert] = @moodle_timeline.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @learner = @moodle_timeline.user
    @edit = true
    @subjects = Subject.order(:category, :name).reject do |subject|
      subject.name.blank? || subject.name.match?(/^P\d/) || subject.id == 101 || subject.id == 578 || subject.id == 105 || subject.id == 575
    end
    @max_date = Date.today + 5.year
    @min_date = Date.today - 5.year
    @subjects_with_timeline_ids = @learner.moodle_timelines.map(&:subject_id)
    @selected_exam_date_id = @moodle_timeline.exam_date_id
    @exam_dates_edit = ExamDate.where(subject_id: @moodle_timeline.subject_id).order(:date)
  end

  def update
    @moodle_timeline = MoodleTimeline.find(params[:id])
    if @moodle_timeline.update(moodle_timeline_params)
      moodle_generate_topic_deadlines(@moodle_timeline)
      @moodle_timeline.save

      if current_user.role != @moodle_timeline.user.role
        redirect_to learner_profile_path(@moodle_timeline.user_id) and return
      else
        redirect_to moodle_timelines_path, notice: 'Moodle Timeline was successfully updated.' and return
      end
    else
      render json: { success: false, error: @moodle_timeline.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_colors
    params[:moodle_timelines].each do |id, moodle_timeline_params|
      moodle_timeline = MoodleTimeline.find(id)
      moodle_timeline.update(moodle_timeline_params.permit(:color))
    end
    redirect_to weekly_goals_navigator_path(date: params[:date]), notice: "Colors updated successfully!"
  end

  def destroy
    @moodle_timeline.destroy
    redirect_to moodle_timelines_url, notice: 'Moodle Timeline was successfully destroyed.'
  end

  def archive
    @moodle_timeline = MoodleTimeline.find(params[:id])
    if @moodle_timeline.update(hidden: true)
      redirect_to moodle_timelines_path, notice: "Moodle Timeline successfully archived."
    else
      redirect_to moodle_timelines_path, alert: "Failed to archive the moodle timeline."
    end
  end

  def toggle_archive
    @moodle_timeline = MoodleTimeline.find(params[:id])
    new_state = !@moodle_timeline.hidden

    if @moodle_timeline.update(hidden: new_state)
      message = new_state ? "Moodle Timeline successfully archived." : "Moodle Timeline successfully reactivated."
      redirect_to moodle_timelines_path, notice: message
    else
      redirect_to moodle_timelines_path, alert: "Failed to toggle the state of the moodle timeline."
    end
  end

  def archived
    @learner = current_user
    @archived_moodle_timelines = MoodleTimeline.where(user: @learner, hidden: true)
                                  .includes(subject: :topics)
    @past_holidays = @learner.holidays.where("end_date <= ?", Date.today)

    # Preload all topic IDs from the archived timelines' subjects
    all_topic_ids = @archived_moodle_timelines.flat_map { |t| t.subject.topics.pluck(:id) }.uniq
    @user_topics_by_topic = @learner.moodle_topics.where(topic_id: all_topic_ids).index_by(&:topic_id)
  end

  def sync_moodle
    MoodleApiService.new.create_moodle_timelines_for_learner(current_user.email)

    if false

      current_user.timelines.each do |timeline|
        subject_names << timeline.moodle_topics.map(&:unit)
        combined_names = [timeline.subject.name, timeline.moodle_topics.map(&:unit)]
      end

      @timeline = MoodleTimeline.create(user: current_user,
       subject_id: 666,
       personalized_name: "Lower Secondary Y7",
       start_date: Date.today,
       end_date: Date.today + 1.year,
       total_time: 100,
       category: "LWS",
       hidden: false)

       combined_names.each_with_index do |combined_name, index|
         MoodleTopic.create(user: current_user,
          name: combined_names[1],
          unit: combined_names[0],
          deadline: Date.today + 1.year,
          time: 1,
          timeline_id: @timeline.id,
          order: index + 1
          )
       end
    end

    redirect_to moodle_timelines_path, notice: "Moodle timelines synced successfully."
  end

  def update_topics
    @moodle_timeline = MoodleTimeline.find(params[:id])

    if @moodle_timeline.update_moodle_topics
      render json: { success: true }
    else
      render json: { success: false, error: "Failed to update topics" }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Error updating topics: #{e.message}"
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_moodle_timeline
    @moodle_timeline = MoodleTimeline.find(params[:id])
  end

  def moodle_timeline_params
    permitted = params.require(:moodle_timeline).permit(:user_id, :start_date, :end_date, :total_time, :exam_date_id,
    :mock100, :mock50, :personalized_name, :hidden, :updated_at, :as1, :as2)


    if params[:moodle_timeline][:blocks].present?
      # Convert the form data to a proper boolean array
      blocks_array = [false] * 4
      params[:moodle_timeline][:blocks].each do |index, value|
        blocks_array[index.to_i] = (value == "true")
      end
      permitted[:blocks] = blocks_array
    end

    permitted
  end

  def set_exam_dates(filter_future: false)
    scope = filter_future ? ExamDate.where("date >= ?", Date.today) : ExamDate.all
    @exam_dates = scope.includes(:subject).map do |exam_date|
      { id: exam_date.id, name: exam_date.formatted_date, subject_id: exam_date.subject_id }
    end
  end
end
