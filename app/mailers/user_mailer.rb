class UserMailer < Devise::Mailer
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
         from: 'worktools@bravegenerationacademy.com',
         subject: 'Welcome to the new BGA App!')
  end

  def welcome_cm(cm, password)
    @cm = cm
    @password = password
    mail(to: @cm.email,
         from: 'worktools@bravegenerationacademy.com',
         subject: 'Welcome to the new BGA App!')
  end

  def notifications_summary(user, notifications, lcs_emails)
    @user = user
    @notifications = notifications

    mail(
      to: @user.email,
      cc: lcs_emails,
      from: 'worktools@bravegenerationacademy.com',
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
      from: 'worktools@bravegenerationacademy.com',
      subject: "Don’t Miss Out – Follow Your Child’s Journey on Worktools"
    )
  end

  def admissions_notification(user, message, subject)
    @user = user
    @message = message
    mail(to: @user.email, from: 'worktools@bravegenerationacademy.com', subject: subject)
  end

  def onboarded_parent_email(learner_info)
    @learner = learner_info
    @parent_emails = [@learner.parent1_email, @learner.parent2_email].compact
    return if @parent_emails.blank?

    @parent_names = [@learner.parent1_full_name, @learner.parent2_full_name].compact.join(' & ')
    @learning_coaches = @learner.learning_coaches
    @hub = @learner.hub
    @regional_manager = @hub.regional_manager

    curriculum = @learner.curriculum_course_option.to_s.downcase.gsub(' ', '_')
    hub_type = @hub.hub_type.to_s.downcase.gsub(' ', '_')

    # Determine the template name based on curriculum and hub type
    template = "onboarded_#{curriculum}_#{hub_type}"

    supported_templates = {
      "onboarded_british_curriculum_powered_by_bga" => true,
      "onboarded_american_curriculum_independent" => true
      # TODO: Add entries
    }

    if supported_templates[template]
      mail(
        to: "guilherme@bravegenerationacademy.com", # to: @parent_emails,
        from: 'worktools@bravegenerationacademy.com',
        subject: "Onboarding Day - #{@learner.full_name}",
        template_name: template
      )
    else
      # TODO: Handle other combinations (e.g., fallback template, log, or notify)
      Rails.logger.warn("No onboarding email template available for curriculum: #{curriculum} and hub_type: #{hub_type}")
      # Optionally, raise or return without sending
    end
  end
end
