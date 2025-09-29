class NotificationsController < ApplicationController
  def index
    # Only notifications from February 12, 2024 onward
    earliest_date = Date.today - 3.months
    @notifications = current_user.notifications.where('created_at >= ?', earliest_date).order(created_at: :desc)
    @notifications_unread = @notifications.where(read: false)
    hub_lcs = []
    if current_user.role == 'admin' || current_user.role == 'lc' || current_user.role == 'learner'
      hub_lcs = current_user.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc').reject do |lc|
        lc.hubs.count >= 3 || lc.deactivate
      end
      @lcs_emails = hub_lcs.map(&:email)
    end
    @notifications_by_month = @notifications.group_by { |n| n.created_at.strftime('%B %Y') }
  end

  def new
    @notification = Notification.new
    @users = User.where(deactivate: false).order(:full_name)
    @roles = User.distinct.pluck(:role).compact.sort
    @countries = Hub.distinct.pluck(:country).compact.sort
  end

  def create
    @users = User.where(deactivate: false).order(:full_name)
    @roles = User.distinct.pluck(:role).compact.sort
    @countries = Hub.distinct.pluck(:country).compact.sort

    # Get target users based on parameters
    target_users = get_target_users

    if target_users.empty?
      flash.now[:error] = "No users selected for notification."
      @notification = Notification.new(notification_params)
      render :new and return
    end

    notifications_created = 0
    errors = []

    target_users.each do |user|
      notification = Notification.new(notification_params)
      notification.user = user

      if notification.save
        notifications_created += 1
      else
        errors << "Failed to create notification for #{user.full_name}: #{notification.errors.full_messages.join(', ')}"
      end
    end

    if errors.empty?
      redirect_to notifications_path, notice: "Successfully created #{notifications_created} notification(s)."
    else
      flash.now[:error] = "Some notifications failed to create: #{errors.join('; ')}"
      @notification = Notification.new(notification_params)
      render :new
    end
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

  private

  def notification_params
    params.require(:notification).permit(:message, :link)
  end

  def get_target_users
    target_users = []

    # If specific user IDs are selected
    if params[:user_ids].present?
      user_ids = params[:user_ids].reject(&:blank?)
      target_users += User.where(id: user_ids, deactivate: false)
    end

    # If roles are selected
    if params[:roles].present?
      roles = params[:roles].reject(&:blank?)
      target_users += User.where(role: roles, deactivate: false)
    end

    # If countries are selected
    if params[:countries].present?
      countries = params[:countries].reject(&:blank?)
      target_users += User.joins(users_hubs: :hub)
                          .where(hubs: { country: countries }, deactivate: false)
                          .distinct
    end

    # If "all users" is selected
    if params[:all_users] == "1"
      target_users = User.where(deactivate: false)
    end

    target_users.uniq
  end
end
