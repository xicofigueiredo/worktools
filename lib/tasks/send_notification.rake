namespace :notifications do
  desc "Send notifications to Level 4 Business users, Learning Coaches, and about the Spring Equinox Party"
  task send_notifications: :environment do
    notifications_count = 0
    # subject_ids = [559,569]

    #  Timeline.where(subject_id: subject_ids, hidden: [false, nil]).find_each do |timeline|
    #    user = timeline.user
    #    Notification.find_or_create_by!(
    #      user: user,
    #      message: "Please update your #{timeline.subject.name} timeline."
    #      )
    #      notifications_count += 1
    #  end

    # hub_ids = [174, 191, 153, 168]

    # User.where(role: "lc").or(User.where(role: "admin")).find_each do |user|
    #   next unless (user.hub_ids & hub_ids).any?  # This checks for any overlap between the two arrays
    #   if user.deactivate != true
    #     Notification.find_or_create_by!(
    #       user: user,
    #       link: "",
    #       message: "Dear LC, we have edited back some of the subject's names of your exams' registrations. There is no extra step required from your side."
    #     )
    #     notifications_count += 1
    #   end
    # end

    # User.where(role: "learner").or(User.where(role: "lc")).find_each do |user|
    #   if user.deactivate != true
    #     Notification.find_or_create_by!(
    #       user: user,
    #       link: "",
    #       message: "If you need to change the exam enrollment from an iAL to an AS, please inform Princess accordingly in the Additional Comments."
    #     )
    #     notifications_count += 1
    #   end
    # end
    #
    #
    include Rails.application.routes.url_helpers

    timelines_ids = Timeline.where(exam_date: nil, hidden: false, end_date: Date.today..Date.today + 3.year)
    timelines_ids.each do |timeline|
      user = timeline.user
      next if timeline.user.deactivate == true
      next if timeline.subject.category.in?(['lws7', 'lws8', 'lws9', 'up', 'other'])
      Notification.find_or_create_by!(
        user: user,
        link: edit_timeline_path(timeline),
        message: "Please update your #{timeline.subject.name || timeline.personalized_name} timeline exam season, if it doesn't save check if the end date is set to a valid date."
      )
      notifications_count += 1
    end

    puts "Completed: #{notifications_count} notifications sent."



      # Notify Learning Coaches with the list of learners
      #  learners_by_coach.each do |coach, learner_names|
      #    next if learner_names.empty?
      #    Notification.find_or_create_by!(
        #      user: coach,
        #      message: "The following learners are using an outdated version of the Level 4 Business timeline: #{learner_names.join(', ')}. Please confirm with them."
        #    )
        #  end

#     User.where(role: "learner").or(User.where(role: "lc")).or(User.where(role: "admin")).find_each do |user|
#       if user.role == 'lc'
#         # Notification for LCs about encouraging learners to fill out feedback forms
#         Notification.find_or_create_by!(
#           user: user,
#           message: "Please encourage your learners to fill in the subjects' feedback form."
#         )
#       elsif user.role == 'learner' || user.role == 'admin'
#         # Notification for learners and admins about new forms to fill
#         Notification.find_or_create_by!(
#           user: user,
#           message: "You have new forms to fill, please check on the notifications page."
#         )
#       end

#       # Notification for ALL users (LCs, learners, and admins) about the Spring Equinox Party
#       Notification.find_or_create_by!(
#         user: user,
#         message: "
# 🌸Join the 1st edition of BGA for Change's Spring Equinox Party🪻
# Details:
# Location: CCB Hub
# Date: Thursday, March 20th
# Time: 17h - 19h30
# The fee for this fun is 5€, please register and pay in the link bellow.

# Funds raised will be donated to support Brave Future; contribute to start this Spring by supporting our community 💙
# We hope to see you there!🌹"
#       )
#       notifications_count += 1
#     end

#     puts "Completed: #{notifications_count} notifications sent."

  end
end
