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

  def onboarding_email(learner_info)
    @learner = learner_info
    @parent_emails = [@learner.parent1_email, @learner.parent2_email].compact
    @learner_email = @learner.personal_email.presence || @learner.institutional_email

    return if @parent_emails.blank? && @learner_email.blank?

    @parent_names       = [@learner.parent1_full_name, @learner.parent2_full_name].compact.join(' & ')
    @learning_coaches   = @learner.learning_coaches || []
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

    # --- Standardize variables for template naming ---
    hub_type   = hub_type_raw.gsub(' ', '_')

    # --- Build template name ---
    if is_up && up_program
      # UP programs now use the standard hub_type in the name (e.g., onboarded_up_business_online)
      template = "onboarded_up_#{up_program}_#{hub_type}"
    else
      # Standard curriculum naming (e.g., onboarded_portuguese_independent_hybrid)
      curriculum = curriculum_raw.gsub(' ', '_')
      template   = "onboarded_#{curriculum}_#{hub_type}"
    end

    # --- Full path to template file ---
    template_path = "onboarding/#{template}"
    full_path     = Rails.root.join("app/views/user_mailer/#{template_path}.html.erb")

    unless File.exist?(full_path)
      Rails.logger.warn("Onboarding template not found: #{template_path} (curriculum: #{curriculum_raw}, hub_type: #{hub_type_raw})")
      return
    end

    @platform_details = [
        "Username: #{@learner.platform_username}",
        "Password: #{@learner.platform_password}"
      ].join("<br>").html_safe

    # --- Recipient & subject ---
    real_to = []
    real_to << @learner_email if @learner_email.present?

    # Only add parents if NOT UP program
    unless is_up
      real_to.concat(@parent_emails)
    end

    real_to.map!(&:to_s)
    real_to.uniq!

    learning_coach_emails = @learning_coaches.map { |u| u&.email }.compact
    regional_manager_email = @regional_manager&.email
    real_cc = (learning_coach_emails + [regional_manager_email]).compact.uniq

    if is_up
      real_cc << "esther@bravegenerationacademy.com"
    end

    real_cc.uniq!

    subject = is_up ? "Welcome to the UP Program!" : "Onboarding Day - #{@learner.full_name}"

    # --- Attachments for everyone ---
    attachments['Calendar.pdf'] = File.read(Rails.root.join('public', 'documents', 'calendar_2025.pdf'))
    attachments['MicrosoftAuthenticator.pdf'] = File.read(Rails.root.join('public', 'documents', 'microsoft_authenticator.pdf'))
    credentials = @learner.learner_documents.find_by(document_type: 'credentials')
    if credentials&.file&.attached?
      attachments["Credentials_Document.pdf"] = {
        mime_type: credentials.file.blob.content_type,
        content: credentials.file.download
      }
    end

    # --- Curriculum-specific attachments ---
    handbook_curricula = %w(portuguese british own american)
    welcome_letter_curricula = %w(british american own)
    billing_guide_curricula = %w(portuguese)

    unless is_up
      if handbook_curricula.any? { |k| curriculum_raw.include?(k) }
        attachments['Handbook.pdf'] = File.read(Rails.root.join('public', 'documents', 'handbook.pdf'))
      end

      if billing_guide_curricula.any? { |k| curriculum_raw.include?(k) }
        attachments['Billing_Guide.pdf'] = File.read(Rails.root.join('public', 'documents', 'billing_guide.pdf'))
      end

      if welcome_letter_curricula.any? { |k| curriculum_raw.include?(k) }
        begin
          generator = WelcomeLetterGenerator.new(@learner.full_name.split.first)
          attachments['Welcome_Letter.pdf'] = generator.generate
        rescue => e
          Rails.logger.error("Failed to generate welcome letter for #{@learner.full_name}: #{e.message}")
        end
      end
    end

    if template.start_with?('onboarded_up_')
      # --- Assign mentors based on program and level ---
      case up_program
      when 'business'
        # Business mentors differ by level
        if @learner.grade_year == 'Level 4'
          @mentor_name = "Rafael Escobar"
          @mentor_email = "rafael.escobar@edubga.com"
        else
          @mentor_name = "Vanessa Gomes"
          @mentor_email = "vanessa.gomes@edubga.com"
        end
      when 'computing'
        @mentor_name = "Cameron Dorning"
        @mentor_email = "cameron.dorning@genexinstitute.com"
      when 'sports'
        @mentor_name = "Aubrey Stout"
        @mentor_email = "aubrey.stout@etacollege.com"
      end
    end

    Rails.logger.info("Onboarding email prepared. REAL_TO: #{real_to.inspect} REAL_CC: #{real_cc.inspect} SUBJECT: #{subject}")
    puts "Onboarding email prepared. REAL_TO: #{real_to.inspect} REAL_CC: #{real_cc.inspect} SUBJECT: #{subject}"

    # --- Send email --- Prod
    mail(
      to: real_to,
      cc: real_cc,
      from:          ApplicationMailer::FROM_CONTACT,
      subject:       subject,
      template_name: template_path
    )

    #--- Send email --- Dev
    # mail(
    #   to: "guilherme@bravegenerationacademy.com",
    #   from:          ApplicationMailer::FROM_CONTACT,
    #   subject:       subject,
    #   template_name: template_path
    # )
  end

  def hub_visit_confirmation(visit)
    @visit = visit
    @hub = visit.hub
    @lcs = @hub.learning_coaches.map { |u| u.try(:full_name) || u.email }.to_sentence

    cc_list = @hub.all_cc_emails
    cc_list << ApplicationMailer::FROM_CONTACT

    mail(
      to: @visit.email,
      cc: cc_list.uniq,
      from: ApplicationMailer::FROM_CONTACT,
      subject: "Your Hub Visit for #{@hub.name} Is Confirmed!"
    )
  end

  def trial_day_confirmation(visit)
    @visit = visit
    @hub = visit.hub
    @lcs = @hub.learning_coaches.map { |u| u.try(:full_name) || u.email }.to_sentence

    cc_list = @hub.all_cc_emails
    cc_list << ApplicationMailer::FROM_CONTACT

    mail(
      to: @visit.email,
      cc: cc_list.uniq,
      from: ApplicationMailer::FROM_CONTACT,
      subject: "Your Trial Day Is Booked!"
    )
  end
end
