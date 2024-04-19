class LwsTimelinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lws_timeline, only: [:show, :edit, :update, :destroy]

  def index
    @lws_timelines = current_user.lws_timelines
  end

  def new
    @lws_timeline = current_user.lws_timelines.new
  end

  def create
    @lws_timeline = current_user.lws_timelines.new(lws_timeline_params)
    @lws_timeline.blocks_per_day = blocks_per_day(@lws_timeline)
    if @lws_timeline.save
      # Since user_topics_data is not used during creation, we can pass an empty hash or nil.
      create_timelines_for_subjects(@lws_timeline)
      redirect_to root_path, notice: 'LWS Timeline and associated timelines were successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      if @lws_timeline.update(lws_timeline_params)
        recreate_timelines_for_subjects(@lws_timeline)
        redirect_to root_path, notice: 'LWS Timeline and associated timelines were successfully updated.'
      else
        render :edit
      end
    end
  end




  def destroy
    @lws_timeline.destroy
    redirect_to root_path, notice: 'LWS Timeline was successfully destroyed.'
  end

  private

  def set_lws_timeline
    @lws_timeline = LwsTimeline.find(params[:id])
  end

  def lws_timeline_params
    params.require(:lws_timeline).permit(:user_id, :start_date, :end_date, :level)
  end

  def blocks_per_day(lws_timeline)
    days = (lws_timeline.end_date - lws_timeline.start_date).to_i
    blocks = 0

    Subject.where(category: lws_timeline.level).each do |subject|
      blocks += subject.topics.sum(:time)
    end

    blocks / days
  end

  def create_timelines_for_subjects(lws_timeline)
    subjects = Subject.where(category: lws_timeline.level)
    return if subjects.empty?

    total_days = (lws_timeline.end_date - lws_timeline.start_date).to_i
    days_per_subject = total_days / subjects.count

    subjects.each_with_index do |subject, index|
      # Calculate the start date for the current subject's timeline
      start_date = lws_timeline.start_date + (days_per_subject * index).days

      # Calculate the end date, handle the last subject separately to account for remainder days
      end_date = (index == subjects.size - 1) ?
                  lws_timeline.end_date :
                  start_date + days_per_subject.days - 1.day

      # Create the timeline
      new_timeline = Timeline.create!(
        user_id: lws_timeline.user_id,
        subject_id: subject.id,
        start_date: start_date,
        end_date: end_date,
        lws_timeline_id: lws_timeline.id
      )

      # Here, you would restore user_topics data if applicable
      # restore_user_topics(user_topics_data)
    end
  end


  # def restore_user_topics(user_topics_data)
  #   user_topics_data.each do |ut_id, done_status|
  #     # Find the topic ID associated with this user topic.
  #     topic_id = Topic.find(ut_id).topic_id

  #     # Ensure the new timeline is associated with this topic.
  #     timeline = Timeline.find_by(user_id: current_user.id, subject_id: Subject.find_by(topic_id: topic_id))

  #     # Recreate the user topic with the associated new timeline and old done status.
  #     UserTopic.create!(
  #       topic_id: topic_id,
  #       user_id: current_user.id,
  #       timeline_id: timeline.id,
  #       done: done_status
  #     )
  #   end
  # end

  def recreate_timelines_for_subjects(lws_timeline)
    # Delete existing timelines
    lws_timeline.timelines.destroy_all
    # Recreate timelines and restore user topics
    create_timelines_for_subjects(lws_timeline)
    # restore_user_topics(user_topics_data)
  end



  # def save_user_topics_data(lws_timeline)
  #   user_topics_data = {}

  #   # Assuming subjects are grouped by a field like `level` in LwsTimeline which matches with subjects
  #   subject_ids = Subject.where(category: lws_timeline.level).pluck(:id)

  #   user_topics = UserTopic.joins(topic: :subject)
  #                          .where(user_id: lws_timeline.user_id, subjects: { id: subject_ids })
  #                          .where("topics.created_at BETWEEN ? AND ?", lws_timeline.start_date, lws_timeline.end_date)

  #   user_topics.each do |ut|
  #     user_topics_data[ut.topic_id] = ut.done
  #   end

  #   user_topics_data
  # end





end
