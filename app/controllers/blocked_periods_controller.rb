class BlockedPeriodsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_hr_admin

  def create
    @blocked_period = BlockedPeriod.new(blocked_period_params)

    if @blocked_period.save
      redirect_to leaves_path(active_tab: 'calendar', year: @blocked_period.start_date.year), notice: 'Blocked Period created successfully.'
    else
      redirect_to leaves_path(active_tab: 'calendar'), alert: "Error creating blocked period: #{@blocked_period.errors.full_messages.join(', ')}"
    end
  end

  private

  def blocked_period_params
    p = params.require(:blocked_period).permit(:start_date, :end_date, :hub_id, :department_id, :user_id, :user_type)

    # Clean up empty strings to ensure database constraints work
    p[:hub_id] = nil if p[:hub_id].blank?
    p[:department_id] = nil if p[:department_id].blank?

    if p[:user_id].present?
      p[:user_type] = 'User'
    else
      p[:user_id] = nil
      p[:user_type] = nil
    end

    p
  end

  def ensure_hr_admin
    unless current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'
      redirect_to root_path, alert: 'Not authorized'
    end
  end
end
