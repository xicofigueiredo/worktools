namespace :notifications do
  desc "Send notifications"
  task create_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner'
        Notification.find_or_create_by!(
          user: user,
          message: "If your report includes subjects that shouldn't appear, please let your Learning Coach know"
        )
        notifications_count += 1
      elsif user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: "If a learner's report includes subjects that shouldn't appear, please message Luís Brito e Faro with the learner's email address and the subjects to be removed."
        )
        notifications_count += 1
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
