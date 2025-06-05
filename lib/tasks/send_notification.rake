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

    # hub_ids = [148, 151, 152, 153, 154, 155, 156, 157, 158, 160, 161, 162, 163, 164, 165, 167, 168, 169, 170, 171, 172, 175, 176, 178, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 192]

    User.where(role: "lc").or(User.where(role: "learner")).find_each do |user|
      # next unless (user.hub_ids & hub_ids).any?  # This checks for any overlap between the two arrays
        Notification.find_or_create_by!(
          user: user,
          link: "https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZTY1M2Q4MTYtMDJhMC00YWE4LTgxYjEtNmNkMWJiNzUxOGY0%40thread.v2/0?context=%7b%22Tid%22%3a%221ac2d08d-bbbe-4e3c-9622-88fbe8ac9830%22%2c%22Oid%22%3a%22b2f38093-aa8e-4086-b774-338ec8512012%22%7d ",
          message: "Final University Workshop of the 24/25 Academic Season

On Wednesday, June 11th at 11am, we’ll be hosting the last University Workshop of the 24/25 Academic season. This session will be led by Hyll Education and is especially relevant for learners still aiming for a 2025 university start.
�� We’ll cover:
What options are available if a learner hasn’t secured a university place yet
Steps for those who are late in applying
Key preparation tips for learners planning to apply to universities in the USA for 2026 start – particularly what should be done over the summer
Meeting link bellow!"
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
