namespace :notifications do
  desc "Send notifications"
  task send_notifications: :environment do
    notifications_count = 0
    subject_ids = [590]

    Timeline.where(subject_id: subject_ids, hidden: [false, nil]).find_each do |timeline|
      user = timeline.user
        Notification.find_or_create_by!(
          user: user,
          message: "Some changes were made, please update your #{timeline.subject.name} timeline."
        )
        notifications_count += 1
    end

    puts "Completed: #{notifications_count} notifications."
  end
end
