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
      create_timelines_for_subjects(@lws_timeline)
      redirect_to root_path, notice: 'LWS Timeline and associated timelines were successfully created.'
    else
      render :new
    end
  end

  def destroy
    @lws_timeline.destroy
    redirect_to lws_timelines_url, notice: 'LWS Timeline was successfully destroyed.'
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

    start_date = lws_timeline.start_date
    end_date = lws_timeline.end_date
    date_range = (start_date..end_date).to_a

    subjects.each_with_index do |subject, index|
      timeline_attrs = {
        user_id: current_user.id,
        subject_id: subject.id,
        start_date: start_date,
        end_date: index == subjects.size - 1 ? end_date : start_date + date_range.size.div(subjects.size) - 1,
        lws_timeline_id: lws_timeline.id
      }
      Timeline.create!(timeline_attrs)

      start_date = timeline_attrs[:end_date] + 1
    end
  end
end
