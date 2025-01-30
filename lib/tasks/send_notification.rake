namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner' || user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: 'Last week issues on sprint goals and attendance were fixed. sorry for the inconvenience that could generated.  Thank you!'
        )
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
