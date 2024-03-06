class HolidaysController < ApplicationController
  before_action :set_holiday, only: [ :edit, :update, :destroy]

  def new
    @holiday = current_user.holidays.new
  end

  def edit
  end

  def create
    @holiday = current_user.holidays.new(holiday_params)

    if @holiday.save
      redirect_to root_path, notice: 'Holiday was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to root_path, notice: 'Holiday was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @holiday.destroy
    redirect_to root_path, notice: 'Holiday was successfully destroyed.'
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params.require(:holiday).permit(:user_id, :start_date, :end_date, :name, :bga)
    end
end
