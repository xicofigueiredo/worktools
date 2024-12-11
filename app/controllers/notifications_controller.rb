class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.where(read: false)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notifications_path, notice: "Notification marked as read."
  end
end
