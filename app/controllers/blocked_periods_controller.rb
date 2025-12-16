class BlockedPeriodsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_authorized_user

  def create
    @blocked_period = BlockedPeriod.new(blocked_period_params)

    @blocked_period.creator = current_user

    if @blocked_period.save
      redirect_back(fallback_location: leaves_path(active_tab: 'calendar', year: @blocked_period.start_date.year), notice: 'Blocked Period created successfully.')
    else
      redirect_back(fallback_location: leaves_path(active_tab: 'calendar'), alert: "Error creating blocked period: #{@blocked_period.errors.full_messages.join(', ')}")
    end
  end

  def destroy
    @blocked_period = BlockedPeriod.find(params[:id])
    year = @blocked_period.start_date.year

    # HR/Admin can delete anything. LCs can only delete their own.
    if is_hr_or_admin? || @blocked_period.creator_id == current_user.id
      @blocked_period.destroy
      redirect_back(fallback_location: leaves_path(active_tab: 'calendar', year: year), notice: 'Blocked Period deleted.')
    else
      redirect_back(fallback_location: leaves_path(active_tab: 'calendar', year: year), alert: 'You do not have permission to delete this block.')
    end
  end

  private

  def blocked_period_params
    p = params.require(:blocked_period).permit(:start_date, :end_date, :hub_id, :department_id, :user_id, :user_type)

    # Clean up empty strings
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

  def is_hr_or_admin?
    current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'
  end

  def ensure_authorized_user
    # Allow HR, Admin, OR Learning Coaches
    unless is_hr_or_admin? || current_user.role == 'lc'
      redirect_to root_path, alert: 'Not authorized'
    end
  end
end
