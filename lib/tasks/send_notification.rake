namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    User.find_each do |user|
      if user.role == 'learner'
        subjects = user.timelines.pluck(:subject_id)
        if subjects.include?(454) || subjects.include?(455) || subjects.include?(575)
          Notification.find_or_create_by!(
            user: user,
            message: "Some changes were made to AS Biology and Portuguese Second Language timelines. Please update those."
          )
          notifications_count += 1
        end
        Notification.find_or_create_by!(
          user: user,
          message: "Please make sure that you are using the Google Chrome browser. Any other browser will most likely cause you problems, such as losing data."
        )
        notifications_count += 1
      elsif user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: "Please make sure that you and your learners are using the Google Chrome browser. Any other browser will most likely cause you problems, such as losing data."
        )
        notifications_count += 1
      end
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
