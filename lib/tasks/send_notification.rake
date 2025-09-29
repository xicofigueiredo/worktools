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

    hub_ids = Hub.where(country: "Portugal").pluck(:id)

    User.where(role: "guardian").or(User.where(role: "guardian")).find_each do |user|
      # next unless (user.hub_ids & hub_ids).any?  # This checks for any overlap between the two arrays
      send = false

      # Filter out nil/invalid kid IDs and only process valid ones
      valid_kids = user.kids&.compact&.reject(&:blank?) || []

      valid_kids.each do |kid_id|
        begin
          kid = User.find(kid_id)
          # Check if the kid belongs to any of the Portuguese hubs
          if kid.users_hubs.where(hub_id: hub_ids).exists? && kid.deactivate != true
            send = true
          end
        rescue ActiveRecord::RecordNotFound
          # Skip if kid doesn't exist
          puts "Warning: Kid with ID #{kid_id} not found for guardian #{user.email}"
          next
        end
      end

      if user.deactivate != true && send #&& main_hub&.hub_id.in?(hubs_ids)
        Notification.find_or_create_by!(
          user: user,
          link: "",
          message: "Important Information – We’re Here to Help

Dear Parents and Guardians,

At Brave Generation Academy, we deeply value the trust you place in us and want you to always feel supported in every step of your child’s educational journey.

If, at any time, you are contacted by a public entity with questions about your choice to enrol your child at BGA, we kindly encourage you to reach out to us before taking any action or responding. We are here to guide you, offer clarification, and help ensure that all information is communicated clearly, calmly, and with your child’s best interests in mind.

Our aim is for you to feel confident and at ease in your decision, knowing that any questions or concerns will be addressed thoughtfully and in partnership with you.

You can always count on us.

Warm regards,
The BGA Team

Portuguese:

Informação Importante – Estamos Aqui para Ajudar

Caros Pais e Encarregados de Educação,

Na Brave Generation Academy, valorizamos muito a confiança que depositam em nós e queremos garantir que se sentem apoiados ao longo do percurso educativo dos vossos filhos.

Se, em algum momento, forem contactados por qualquer entidade pública a questionar a vossa opção de inscrição na BGA, pedimos que, antes de tomarem qualquer decisão ou de responderem, entrem em contacto conosco. Estamos totalmente disponíveis para vos orientar, esclarecer e garantir que toda a informação é comunicada de forma clara, tranquila e tendo sempre em mente os melhores interesses da criança.

O nosso objetivo é assegurar que se sentem seguros e confiantes na vossa escolha, sabendo que qualquer dúvida ou questão será tratada da melhor forma possível, sempre em parceria convosco.

Contem sempre conosco.

Com os melhores cumprimentos,
A Equipa da Brave Generation Academy"
        )
        notifications_count += 1
      end
    end
    #
#     users =  ["Manuel.Jordao@edubga.com",
#     "Hannah.Cataldo@edubga.com",
#     "Ilan.Flak@edubga.com",
#     "Sofia.Alonso@edubga.com",
#     "Naia.Lincoln@edubga.com",
#     "Jamie.Huber@edubga.com",
#     "Goncalo.Almeida@edubga.com",
#     "nohambagrace@gmail.com",
#     "Lucas.Wehle@edubga.com",
#     "Chimu.Yasuda@edubga.com",
#     "Declan.Lombardi@edubga.com",
#     "Finlay.Low@edubga.com",
#     "Gaspar.Bonacho@edubga.com",
#     "Mees.Rodenburg@edubga.com",
#     "Mia.Pires@edubga.com",
#     "Sara.Krnic@edubga.com",
#     "Zoey.Weaver@edubga.com",
#     "Ilay.Ziv@edubga.com",
#     "Marta.Frota@edubga.com",
#     "Joshua.Smith@edubga.com",
#     "Lilian.Smith@edubga.com",
#     "Noah.Sweeney@edubga.com",
#     "Kieran.Mercurio@edubga.com",
#     "Madeline.Mandarino@edubga.com",
#     "Hare.Natori@edubga.com",
#     "Maximilian.Hong@edubga.com",
#     "Guan.Liming@edubga.com",
#     "Ilay.Daniel@edubga.com",
#     "Caden.melvin@edubga.com",
#     "claire.cannon@edubga.com",
#     "Michael.Aviv@edubga.com",
#     "carter.pearce@edubga.com",
#     "jane.velychko@edubga.com",
#     "Kingsley.Pearson@edubga.com",
#     "Pablo.Gistau@edubga.com",
#     "Sophia.Lundin@edubga.com",
#     "or.dakon@edubga.com",
#     "curtis.ho@edubga.com",
#     "Caetana.Cardoso@edubga.com",
#     "nicole.ferreira@edubga.com",
#     "choying.pelmo@edubga.com",
#     "Elisa.Barre@edubga.com",
#     "Ella.Nachtergaele@edubga.com",
#     "yara.pinto@edubga.com",
#     "Ada.Schiller@edubga.com",
#     "michael.kochavi@edubga.com",
#     "keirnan.miller@edubga.com",
#     "Lila.Reynolds@edubga.com",
#     "sergiodearaujo2@outlook.com",
#     "maireadnmcg@gmail.com",
#     "halleacampbell@gmail.com",
#     "lincoln7p@gmail.com",
#     "catiaferreirapfacademy@gmail.com",
#     "dgautier23@icloud.com",
#     "diegosinathrya2009@gmail.com",
#     "julesg2009@outlook.com",
#     "yabaye40@gmail.com",
#     "amanda.rombaut@edubga.com",
#     "solaris.ewagrochowska@gmail.com",
#     "ninkagroszek@gmail.com",
#     "nir.erlich@gmail.com",
#     "liorzarchi2009@gmail.com",
#     "yesiam.maisey85@gmail.com",
#     "sarah.kassam@edubga.com",
#     "vascolopes2008@gmailcom",
#     "oeribenne@yahoo.com",
#     "gbasciu3@gmail.com",
#     "write2moris@icloud.com",
#     "sebsm2010@icloud.com",
#     "Somtoeribenne@gmail.com",
#     "caetanoguerraalves@gmail.com",
#     "dan@sorlander.com",
#     "meifonseca13@gmail.com",
#     "maximilian.sibony@edubga.com",
#     "uri.zekbach@gmail.com",
#     "alayalaubsch@gmail.com"]

#     users.each do |email|
#       #ignore capital letters
#       email = email.downcase
#       user = User.find_by(email: email)
#       if user.present?
#         Notification.find_or_create_by!(
#           user: user,
#           message: "Hello #{user.full_name},

# We’re excited to share that you’ll be transitioning from Ecampus to FIA!

# This change won’t affect your platform, credits, or progress, everything you’ve achieved so far from credits and progress will stay exactly the same.

# If you have any questions, feel free to reach out to your Learning Coach."
#         )
#       end
#     end


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
    # include Rails.application.routes.url_helpers

    # timelines_ids = Timeline.where(exam_date: nil, hidden: false, end_date: Date.today..Date.today + 3.year)
    # timelines_ids.each do |timeline|
    #   user = timeline.user
    #   next if timeline.user.deactivate == true
    #   next if timeline.subject.category.in?(['lws7', 'lws8', 'lws9', 'up', 'other'])
    #   Notification.find_or_create_by!(
    #     user: user,
    #     link: edit_timeline_path(timeline),
    #     message: "Please update your #{timeline.subject.name || timeline.personalized_name} timeline exam season, if it doesn't save check if the end date is set to a valid date."
    #   )
    #   notifications_count += 1
    # end

    # puts "Completed: #{notifications_count} notifications sent."



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
