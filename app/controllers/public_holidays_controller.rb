class PublicHolidaysController < ApplicationController
  before_action :authenticate_user! # Adjust based on your auth setup
  before_action :ensure_hr_admin

  def create
    @public_holiday = PublicHoliday.new(public_holiday_params)

    if @public_holiday.save
      redirect_to leaves_path(active_tab: 'calendar', year: @public_holiday.date.year), notice: 'Public Holiday created successfully.'
    else
      redirect_to leaves_path(active_tab: 'calendar'), alert: "Error creating holiday: #{@public_holiday.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @public_holiday = PublicHoliday.find(params[:id])
    year = @public_holiday.date.year

    @public_holiday.destroy

    redirect_to leaves_path(active_tab: 'calendar', year: year), notice: 'Public Holiday deleted.'
  end

  private

  def public_holiday_params
    params.require(:public_holiday).permit(:name, :date, :recurring, :country, :hub_id)
  end

  def ensure_hr_admin
    # Copy your logic from leaves controller or use a policy
    unless current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'
      redirect_to root_path, alert: 'Not authorized'
    end
  end
end
