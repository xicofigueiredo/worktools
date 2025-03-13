namespace :notifications do
  desc "Send notifications to Level 4 Business users and Learning Coaches"
  task send_notifications: :environment do
    notifications_count = 0
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

    User.where(role: "learner").or(User.where(role: "lc")).or(User.where(role: "admin")).find_each do |user|
      if user.role == 'lc'
        Notification.find_or_create_by!(
          user: user,
          message: "Please encourage your learners to fill in the subjects' feedback form."
        )
      elsif user.role == 'learner' || user.role == 'admin'
        Notification.find_or_create_by!(
          user: user,
          message: "You have new forms to fill, please check on the notifications page."
        )
      end
      notifications_count += 1
    end



    puts "Completed: #{notifications_count} notifications."
  end
end
