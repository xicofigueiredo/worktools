namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner' || user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: "Good news! The issues affecting last week’s sprint goals have hopefully been resolved. We apologize for any inconvenience this may have caused. Thank you for your patience!"
        )
        notifications_count +=1
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
