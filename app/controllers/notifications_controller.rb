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
    @notifications_by_month = @notifications.group_by { |n| n.created_at.strftime('%B %Y') }
  end

  def mark_as_read
    notification = Notification.find(params[:id])
    if notification.update(read: true)
      respond_to do |format|
        format.html {
          flash[:success] = "Notification marked as resolved."
          redirect_back fallback_location: profile_path
        }
        format.json {
          render json: { status: 'success' }
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Unable to mark notification as resolved."
          redirect_back fallback_location: profile_path
        }
        format.json {
          render json: { status: 'error' }, status: :unprocessable_entity
        }
      end
    end
  end

  def mark_all_as_read
    current_user.notifications.where(read: false).update_all(read: true)
    redirect_to notifications_path, notice: "All notifications marked as resolved."
  end
end
