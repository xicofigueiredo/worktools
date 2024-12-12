class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.where(read: false)
  end

  def mark_as_read
    notification = Notification.find(params[:id])
    if notification.update(read: true)
      flash[:success] = "Notification marked as resolved."
    else
      flash[:error] = "Unable to mark notification as resolved."
    end
    redirect_back fallback_location: profile_path
  end
end
