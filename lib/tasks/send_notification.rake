namespace :notifications do
  desc "Send notifications to Level 4 Business users, Learning Coaches, and about the Spring Equinox Party"
  task send_notifications: :environment do
    notifications_count = 0

    User.where(role: "learner").or(User.where(role: "lc")).or(User.where(role: "admin")).find_each do |user|
      if user.role == 'lc'
        # Notification for LCs about encouraging learners to fill out feedback forms
        Notification.find_or_create_by!(
          user: user,
          message: "Please encourage your learners to fill in the subjects' feedback form."
        )
      elsif user.role == 'learner' || user.role == 'admin'
        # Notification for learners and admins about new forms to fill
        Notification.find_or_create_by!(
          user: user,
          message: "You have new forms to fill, please check on the notifications page."
        )
      end

      # Notification for ALL users (LCs, learners, and admins) about the Spring Equinox Party
      Notification.find_or_create_by!(
        user: user,
        message: "
🌸Join the 1st edition of BGA for Change’s Spring Equinox Party🪻
Details:
Location: CCB Hub
Date: Thursday, March 20th
Time: 17h - 19h30
The fee for this fun is 5€, please register and pay in the link bellow.

Funds raised will be donated to support Brave Future; contribute to start this Spring by supporting our community 💙
We hope to see you there!🌹"
      )
      notifications_count += 1
    end

    puts "Completed: #{notifications_count} notifications sent."
  end
end




    # subject_ids = [595]
    # excluded_emails = [
    #   "mehek.dass@edubga.com",
    #   "antonio.schneider@edubga.com",
    #   "maud.miribel@edubga.com"
    # ]

    # learners_by_coach = Hash.new { |hash, key| hash[key] = [] }

    # # Fetch all learning coaches who have learners with the timeline
    # User.joins(users_hubs: :hub)
    #     .where(users_hubs: { main: true })
    #     .where(role: 'lc')
    #     .find_each do |coach|

    #   learners = User.joins(users_hubs: :hub)
    #                  .where(users_hubs: { hub_id: coach.hubs.pluck(:id) })
    #                  .where(role: 'learner')
    #                  .joins(:timelines)
    #                  .where(timelines: { subject_id: subject_ids, hidden: [false, nil] })
    #                  .where.not(email: excluded_emails)

    #   learners.each do |learner|
    #     learners_by_coach[coach] << learner.full_name

    #     Notification.find_or_create_by!(
    #       user: learner,
    #       message: "It seems that you are using an outdated version of the Level 4 Business timeline, please confirm so with your Learning Coach."
    #     )
    #     notifications_count += 1
    #   end
    # end

    # # Notify Learning Coaches with the list of learners
    # learners_by_coach.each do |coach, learner_names|
    #   next if learner_names.empty?
    #   Notification.find_or_create_by!(
    #     user: coach,
    #     message: "The following learners are using an outdated version of the Level 4 Business timeline: #{learner_names.join(', ')}. Please confirm with them."
    #   )
    # end
