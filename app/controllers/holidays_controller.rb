class HolidaysController < ApplicationController
  include GenerateTopicDeadlines

  before_action :set_holiday, only: %i[edit update destroy]

  def new
    @holiday = current_user.holidays.new
  end

  def edit
    @edit = true
  end

  def create
    @holiday = current_user.holidays.new(holiday_params)

    if @holiday.save
      current_user.moodle_timelines.where(hidden: false).each do |timeline|
        moodle_generate_topic_deadlines(timeline)
        timeline.save
      end
      current_user.timelines.where(hidden: false).each do |timeline|
        generate_topic_deadlines(timeline)
        timeline.save
      end
      redirect_to moodle_timelines_path, notice: 'Holiday was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @holiday.update(holiday_params)
      current_user.moodle_timelines.where(hidden: false).each do |timeline|
        moodle_generate_topic_deadlines(timeline)
        timeline.save
      end
      redirect_to moodle_timelines_path, notice: 'Holiday was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @holiday.destroy
    current_user.moodle_timelines.where(hidden: false).each do |timeline|
      moodle_generate_topic_deadlines(timeline)
      timeline.save
    end
    redirect_to moodle_timelines_path, notice: 'Holiday was successfully destroyed.'
  end

  private

  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:user_id, :start_date, :end_date, :name, :bga)
  end
end
