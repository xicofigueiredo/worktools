class UserMailer < Devise::Mailer
  # To send from contact@bravegenerationacademy.com, use:
  # mail(..., from: ApplicationMailer::FROM_CONTACT, ...)
  #
  # To send from worktools@bravegenerationacademy.com (default), use:
  # mail(..., from: ApplicationMailer::FROM_WORKTOOLS, ...)
  # or simply omit the 'from' parameter to use the default

  def confirmation_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Awesome App!')
  end

  # Send password reset instructions
  def reset_password_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  # Send a notification to the userz
  def notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'You Have a New Notification')
  end

  def welcome_parent(parent, password, lcs)
    @parent = parent
    @password = password
    mail(to: @parent.email,
         cc: lcs.map(&:email),
         from: ApplicationMailer::FROM_WORKTOOLS,
         subject: 'Welcome to the new BGA App!')
  end

  def welcome_cm(cm, password)
    @cm = cm
    @password = password
    mail(to: @cm.email,
         from: ApplicationMailer::FROM_WORKTOOLS,
         subject: 'Welcome to the new BGA App!')
  end

  def notifications_summary(user, notifications, lcs_emails)
    @user = user
    @notifications = notifications

    mail(
      to: @user.email,
      cc: lcs_emails,
      from: ApplicationMailer::FROM_WORKTOOLS,
      subject: "Notification Summary: You have #{notifications.size} unread notifications"
    )
  end

  def parent_journey_email(parent)
    @parent = parent
    @name = parent.full_name
    @email = parent.email

    # Get the kids and their associated LCs
    kids = User.where(id: parent.kids)
    # lcs = kids.map { |kid|
    #   kid.users_hubs.find_by(main: true)&.hub&.users&.where(role: 'lc', deactivate: false)
    # }.compact.flatten.select { |lc| lc.hubs.count < 5 }

    mail(
      to: @email,
      # cc: lcs.map(&:email),
      from: ApplicationMailer::FROM_WORKTOOLS,
      subject: "Don't Miss Out – Follow Your Child's Journey on Worktools"
    )
  end

  def admissions_notification(user, message, subject)
    @user = user
    @message = message
    mail(to: @user.email, from: ApplicationMailer::FROM_WORKTOOLS, subject: subject)
    #mail(to: "guilherme@bravegenerationacademy.com", from: 'worktools@bravegenerationacademy.com', subject: subject)
  end

  # TO DO: What is the template? How does it work for up?
  def renewal_fee_email(learner_info)
    to = learner_info.learner_finances.invoice_email
    message = "Renewal Fee"
    mail(to: to, from: 'worktools@bravegenerationacademy.com', subject: "Renewal Fee")
  end

  def onboarding_email(learner:, hub:, to:, cc:, template_name:, attachments_list:, mentor_details: {})
    @learner = learner
    @hub = hub || @learner.hub
    @learning_coaches = @learner.learning_coaches || []
    @regional_manager = @hub&.regional_manager
    @parent_names = [@learner.parent1_full_name, @learner.parent2_full_name].compact.join(' & ')
    @platform_details = [
      "Username: #{@learner.platform_username}",
      "Password: #{@learner.platform_password}"
    ].join("<br>").html_safe

    # Set instance variables for the view
    @mentor_name = mentor_details[:name]
    @mentor_email = mentor_details[:email]

    # Process attachments
    attachments_list.each do |file|
      if file[:blob]
        attachments[file[:name]] = { mime_type: file[:blob].content_type, content: file[:blob].download }
      elsif file[:path] && File.exist?(Rails.root.join(file[:path]))
        attachments[file[:name]] = File.read(Rails.root.join(file[:path]))
      elsif file[:generator]
        # Generate on the fly
        generator = WelcomeLetterGenerator.new(@learner.full_name.split.first)
        attachments[file[:name]] = generator.generate
      end
    end

    # Check if template exists to avoid 500 error
    unless template_exists?("user_mailer/onboarding/#{template_name}")
      Rails.logger.error "Template missing: #{template_name}"
      return
    end

    subject = template_name.include?('up') ? "Welcome to the UP Program!" : "Onboarding Day - #{@learner.full_name}"

    mail(
      to: to,
      cc: cc,
      from: ApplicationMailer::FROM_CONTACT,
      subject: subject,
      template_name: "onboarding/#{template_name}"
    )
  end

  def hub_visit_confirmation(visit)
    @visit = visit
    @hub = visit.hub
    @lcs = @hub.learning_coaches.map { |u| u.try(:full_name) || u.email }.to_sentence

    cc_list = @hub.all_cc_emails
    cc_list << ApplicationMailer::FROM_CONTACT

    attachments['invite.ics'] = {
      mime_type: 'text/calendar',
      content: @visit.to_ics
    }

    mail(
      to: @visit.email,
      cc: cc_list.uniq,
      from: ApplicationMailer::FROM_CONTACT,
      subject: "Your Hub Visit for #{@hub.name} is Confirmed!"
    )
  end

  def trial_day_confirmation(visit)
    @visit = visit
    @hub = visit.hub
    @lcs = @hub.learning_coaches.map { |u| u.try(:full_name) || u.email }.to_sentence

    cc_list = @hub.all_cc_emails
    cc_list << ApplicationMailer::FROM_CONTACT

    attachments['invite.ics'] = {
      mime_type: 'text/calendar',
      content: @visit.to_ics
    }

    mail(
      to: @visit.email,
      cc: cc_list.uniq,
      from: ApplicationMailer::FROM_CONTACT,
      subject: "Your Trial Day is Booked!"
    )
  end
end
