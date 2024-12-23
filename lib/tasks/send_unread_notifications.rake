namespace :notifications do
  desc "Send emails to users with their unread notifications"
  task send_unread_notifications: :environment do
    # Fetch all learners with unread notifications
    User.includes(:notifications)
        .where(role: "learner")
        .where.not(notifications: { id: nil })
        .find_each do |user|

      # Fetch unread notifications
      unread_notifications = user.notifications.where(read: false)
      next if unread_notifications.empty? # Skip users with no unread notifications

      # Fetch Learning Coaches' emails for CC (if applicable)
      lcs_emails = user.hubs.first&.users
                           &.where(role: 'lc')
                           &.select { |lc| lc.hubs.count < 3 }
                           &.pluck(:email) || []

      # Send email
      UserMailer.notifications_summary(user, unread_notifications, lcs_emails).deliver_now

      puts "Email sent to #{user.email} with #{unread_notifications.size} unread notifications."
    end

    puts "All notification emails sent."
  end
end
