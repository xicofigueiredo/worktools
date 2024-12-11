namespace :notifications do
  desc "Send emails to users with their unread notifications"
  task send_unread_notifications: :environment do
    User.includes(:notifications).where.not(notifications: { id: nil }).find_each do |user|
      # Fetch unread notifications
      unread_notifications = user.notifications.where(read: false)

      next if unread_notifications.empty? # Skip users with no unread notifications

      # Fetch LC email for CC (if applicable)
      lcs_emails = @learner.hubs.first.users
      .where(role: 'lc')  
      .select { |lc| lc.hubs.count < 3 } # Reject LCs with 3 or more hubs
      .pluck(:email)

      # Send email
      UserMailer.unread_notifications_summary(user, unread_notifications, lcs_emails).deliver_now

      puts "Email sent to #{user.email} with #{unread_notifications.size} unread notifications."
    end

    puts "All notification emails sent."
  end
end
