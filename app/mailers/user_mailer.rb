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

  def onboarding_email(learner_info)
    @learner = learner_info
    @parent_emails = [@learner.parent1_email, @learner.parent2_email].compact
    @learner_email = @learner.personal_email.presence || @learner.institutional_email

    return if @parent_emails.blank? && @learner_email.blank?

    @parent_names       = [@learner.parent1_full_name, @learner.parent2_full_name].compact.join(' & ')
    @learning_coaches   = @learner.learning_coaches
    @hub                = @learner.hub
    @regional_manager   = @hub.regional_manager

    curriculum_raw = @learner.curriculum_course_option.to_s.downcase
    hub_type_raw   = @hub.hub_type.to_s.downcase

    # --- Detect UP program ---
    is_up = curriculum_raw.include?('up')
    up_program = if curriculum_raw.include?('business')
                  'business'
                elsif curriculum_raw.include?('computing')
                  'computing'
                elsif curriculum_raw.include?('sports')
                  'sports'
                end

    # --- Delivery mode: online = exact, hybrid = everything else ---
    up_mode = hub_type_raw == 'online' ? 'online' : 'hybrid'

    # --- Build template name ---
    if is_up && up_program
      template = "onboarded_up_#{up_program}_#{up_mode}"
    else
      curriculum = curriculum_raw.gsub(' ', '_')
      hub_type   = hub_type_raw.gsub(' ', '_')
      template   = "onboarded_#{curriculum}_#{hub_type}"
    end

    # --- Full path to template file ---
    template_path = "onboarding/#{template}"
    full_path     = Rails.root.join("app/views/user_mailer/#{template_path}.html.erb")

    unless File.exist?(full_path)
      Rails.logger.warn("Onboarding template not found: #{template_path} (curriculum: #{curriculum_raw}, hub_type: #{hub_type_raw})")
      return
    end

    # --- Recipient & subject ---
    to      = @parent_emails
    subject = "Onboarding Day - #{@learner.full_name}"

    if template.start_with?('onboarded_up_')
      to      = @learner_email
      subject = "Welcome to the UP Program!"

      # --- Hard-coded mentors ---
      case up_program
        when 'business'
          @mentor_name = "Placeholder"
          @mentor_email = "Placeholder"
          @platform_details = "Placeholder"
        when 'computing'
          @mentor_name = "Placeholder"
          @mentor_email = "Placeholder"
          @platform_details = "Placeholder"
        when 'sports'
          @mentor_name = "Placeholder"
          @mentor_email = "Placeholder"
          @platform_details = "Placeholder"
      end
    end

    # --- Send email ---
    mail(
      to: "guilherme@bravegenerationacademy.com", # to: to, # Use in production
      from:          'worktools@bravegenerationacademy.com',
      subject:       subject,
      template_name: template_path
    )
  end
end
