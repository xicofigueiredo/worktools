class MandatoryLeavesController < ApplicationController
  before_action :authenticate_user!

  def create
    unless current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'
      return redirect_to leaves_path, alert: "Unauthorized"
    end

    @mandatory_leave = MandatoryLeave.new(mandatory_leave_params)

    if @mandatory_leave.save
      redirect_to leaves_path(active_tab: 'calendar'), notice: "Mandatory leave created and applied to users."
    else
      redirect_to leaves_path(active_tab: 'calendar'), alert: "Error: #{@mandatory_leave.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    unless current_user.email == 'humanresources@bravegenerationacademy.com' || current_user.role == 'admin'
      return redirect_to leaves_path, alert: "Unauthorized"
    end

    @mandatory_leave = MandatoryLeave.find(params[:id])
    @mandatory_leave.destroy # This triggers dependent: :destroy on staff_leaves, restoring entitlements

    redirect_to leaves_path(active_tab: 'calendar'), notice: "Mandatory leave removed."
  end

  private

  def mandatory_leave_params
    params.require(:mandatory_leave).permit(:name, :start_date, :end_date, :global)
  end
end
