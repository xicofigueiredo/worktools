namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner'
        Notification.find_or_create_by!(
          user: user,
          message: "If your name is not entirely correct, please ask your LC to update it manually so that it appears correctly in the sprint report."
        )
        notifications_count += 1
      elsif user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: "If a learner’s name is incorrect, please update it via the LC Dashboard. Otherwise, it will appear incorrectly in the report shared with parents."
        )
        notifications_count += 1
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
