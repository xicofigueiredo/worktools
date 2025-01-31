namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner' || user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: ""
        )
        notifications_count +=1
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
