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
      if user.role == "lc"
        Notification.find_or_create_by!(
          user: user,
          link: "https://forms.office.com/r/CL0H1dXCEZ",
          message: "📣 BGA Brand Ambassador Program – Reminder

Following the internal staff meeting, we’ve launched the BGA Brand Ambassador Program — a fun way for Learners to get involved, share their BGA experience online, and earn up to €7/month for their Hub budget!

Learners must follow the content guidelines for posts to count — all content should be appropriate for BGA’s audience.
Full instructions + video were shared via Central Communication on Teams and are also available on the Marketing SharePoint.
They must submit this form by the last day of the month to be eligible: https://forms.office.com/r/CL0H1dXCEZ
Only those who meet the guidelines and submit the form on time will be eligible for the monthly rewards or the quarterly creative prize. Let’s help them make the most of it!

Thanks for encouraging your Learners to take part!

— The Marketing Team "
        )
      elsif user.role == "learner"
        Notification.find_or_create_by!(
          user: user,
          link: "https://forms.office.com/r/CL0H1dXCEZ",
          message: "Want to earn money for your Hub just by posting on social media?

We’re excited to introduce the BGA Brand Ambassador Program — your chance to get creative, show off your BGA journey, and earn up to €7/month for your Hub budget!

Whether you're sharing a day at your Hub, a sports session, a cool project, or your BGA adventures while travelling  — this is your moment to inspire others and represent BGA online.

You can:
Repost our content on Instagram, or
Create your own original content on Instagram or TikTok

Ask your LCs for more details! They've been given full instructions + a short explainer video.

All you need to do to earn is to submit this form by the last day of every month: https://forms.office.com/r/CL0H1dXCEZ

We can’t wait to see what you create!

— The Marketing Team"
        )
      end
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
