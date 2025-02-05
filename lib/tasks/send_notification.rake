namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    subject_ids = [460, 462, 461, 463, 89, 90, 588, 589, 94, 99, 102 ]

    Timeline.where(subject_id: subject_ids, hidden: [false, nil]).find_each do |timeline|
      user = timeline.user
        Notification.find_or_create_by!(
          user: user,
          message: "Please update your #{timeline.subject.name} timeline."
        )
        notifications_count += 1
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
