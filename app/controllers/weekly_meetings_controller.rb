class WeeklyMeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekly_meeting, only: %i[show edit update destroy]
  before_action :set_available_weeks, only: [:new, :edit, :create, :update]
  before_action :set_user_options, only: [:new, :edit, :create, :update]
  before_action :set_time_slots, only: [:new, :edit, :create, :update]


  def index
    @weekly_meetings = WeeklyMeeting.all
  end

  def show
  end

  def new
    @weekly_meeting = WeeklyMeeting.new
    @weekly_meeting.week = Week.find_by(id: params[:week_id])
    @weekly_meeting.meeting_slots.build
    # Assuming you want all LCs and learners from the hubs the current user belongs to
    @lc_users = User.joins(:hubs).where(role: 'Learning Coach', hubs: { id: current_user.hub_ids }).distinct
    @learner_users = User.joins(:hubs).where(role: 'Learner', hubs: { id: current_user.hub_ids }).distinct
    # Other setup code...
  end

  def edit
    set_available_weeks(@weekly_meeting.week_id)
    @weekly_meeting = WeeklyMeeting.includes(:meeting_slots).find(params[:id])
  end

  def create
    @hub = current_user.hubs.first
    @weekly_meeting = @hub.weekly_meetings.new(weekly_meeting_params)
    set_available_weeks(@weekly_meeting.week_id)

    if @weekly_meeting.save
      redirect_to @weekly_meeting, notice: 'Weekly meeting was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @weekly_meeting.update(weekly_meeting_params)
      redirect_to @weekly_meeting, notice: 'Weekly meeting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @weekly_meeting.destroy
    redirect_to weekly_meetings_url, notice: 'Weekly meeting was successfully destroyed.'
  end

  private

  def set_weekly_meeting
    @weekly_meeting = WeeklyMeeting.find(params[:id])
  end

  def weekly_meeting_params
    params.require(:weekly_meeting).permit(
      :id_weeks, :id_hubs,
      meeting_slots_attributes: [:id, :time_slot, :date, :lc_id, :learner_id, :_destroy]
    )
  end



  def set_available_weeks(edit_week_id = nil)
    used_week_ids = current_user.weekly_goals.pluck(:week_id)

    # Exclude the edit_week_id from used_week_ids if provided
    used_week_ids.delete(edit_week_id) if edit_week_id.present?

    @available_weeks = Week.where.not(id: used_week_ids)

    # Ensure the current week is included if we're editing
    if edit_week_id.present? && !@available_weeks.exists?(edit_week_id)
      @available_weeks = @available_weeks.or(Week.where(id: edit_week_id))
    end
  end

  def set_user_options
    @lc_users = User.joins(:hubs).where(role: 'Learning Coach', hubs: { id: current_user.hub_ids }).distinct
    @learner_users = User.joins(:hubs).where(role: 'Learner', hubs: { id: current_user.hub_ids }).distinct
  end

  def set_time_slots
    @time_slots = %w[ 08:00 08:30 09:00 09:30 10:00 10:30 11:00 11:30 12:00 12:30 13:00 13:30 14:00 14:30 15:00 15:30 16:00 16:30 17:00 17:30 ]
  end

end
