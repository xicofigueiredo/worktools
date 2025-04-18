namespace :notifications do
  desc "Send notifications to Level 4 Business users, Learning Coaches, and about the Spring Equinox Party"
  task send_notifications: :environment do
    notifications_count = 0
    # subject_ids = [559]

    #  Timeline.where(subject_id: subject_ids, hidden: [false, nil]).find_each do |timeline|
    #    user = timeline.user
    #    Notification.find_or_create_by!(
    #      user: user,
    #      message: "Please update your #{timeline.subject.name} timeline."
    #      )
    #      notifications_count += 1
    #  end

    notifications_count = 0

    User.joins(:hubs)
        .where(role: "lc", hubs: { country: ["Portugal", "Mozambique"] })
        .distinct
        .find_each do |user|

      Notification.find_or_create_by!(
        user: user,
        message: "Hi Team,

We’re officially launching the Portuguese+ curriculum on September 1st! This programme will allow Learners to study core subjects in Portuguese, while continuing to benefit from our English-speaking Hub environment and subsidising with access to subjects from the British International Curriculum (if desired).

Key points to know:
Now available for Grades 7–12 (Years 8–13)
Subjects include:
For Grades 7-9: Mathematics, Portuguese, History, Geography, Physics & Chemistry, Natural Sciences, English, Spanish, Information and Communication Technology, and Visual Education.
For Grades 10-12: Portuguese, Mathematics, English, Physics & Chemistry, Biology & Geology, History B, Economics, Psychology B, Philosophy
Pathways: Ciências e Tecnologia and Ciências Socioeconómicas
Learners can use this curriculum to apply to Portuguese universities or pursue international opportunities
We now have partner schools where Learners can register officially and sit their national exams
Trial modules will be released mid-May.
For more detailed information, you can take a look at this document.

Please reach out to Luís Brito e Faro with any questions!"
      )
      notifications_count += 1
    end

    User.joins(:hubs)
    .where(role: "learner", hubs: { country: ["Portugal", "Mozambique"] })
    .distinct
    .find_each do |user|

    Notification.find_or_create_by!(
      user: user,
      message: "Portuguese+ is Launching September 1st!

  We’re excited to let you know that the Portuguese+ curriculum officially launches on September 1st! You can now complete your education in Portuguese, with new subjects and grades available (Grades 7–12).

  You’ll still learn in an English-speaking Hub, follow the BGA model, and have access to British International Curriculum subjects too. But with Portuguese+ you can also apply to Portuguese universities!

  Pathways include:
  Ciências e Tecnologia and Ciências Socioeconómicas

  Want to give it a try? Trials will be available soon—talk to your LCs!"
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
# 🌸Join the 1st edition of BGA for Change’s Spring Equinox Party🪻
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
