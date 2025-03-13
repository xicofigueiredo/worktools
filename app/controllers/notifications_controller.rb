class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @notifications_unread = @notifications.where(read: false)
    hub_lcs = []
    if current_user.role == 'admin' || current_user.role == 'lc' || current_user.role == 'learner'
      hub_lcs = current_user.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc').reject do |lc|
        lc.hubs.count >= 3 || lc.deactivate
        @lcs_emails = hub_lcs.map(&:email)
      end
    end
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
