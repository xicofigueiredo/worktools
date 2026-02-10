class OnboardingEmailService
  attr_reader :learner

  def initialize(learner)
    @learner = learner
    @hub = learner.hub
  end

  # Returns a hash of validation results for the frontend check
  def check_readiness
    {
      already_sent: @learner.onboarding_email_sent?,
      missing_fields: missing_required_fields,
      recipients: calculate_recipients,
      cc_emails: calculate_cc,
      template: template_name
    }
  end

  def perform_delivery!
    # Validate critical data before attempting
    if missing_required_fields.any?
      raise StandardError, "Cannot send email. Missing fields: #{missing_required_fields.join(', ')}"
    end

    # Pass calculated data to the mailer
    UserMailer.onboarding_email(
      learner: @learner,
      hub: @hub,
      to: calculate_recipients,
      cc: calculate_cc,
      template_name: template_name,
      attachments_list: calculate_attachments,
      mentor_details: mentor_details
    ).deliver_now

    @learner.update!(onboarding_email_sent: true)
  end

  private

  def missing_required_fields
    errors = []
    errors << "Hub" if @hub.nil?

    # Email checks
    has_learner_email = @learner.personal_email.present? || @learner.institutional_email.present?
    errors << "Learner Email" unless has_learner_email

    unless is_up_program?
      has_parent_email = @learner.parent1_email.present? || @learner.parent2_email.present?
      errors << "Parent Email" unless has_parent_email
    end

    errors
  end

  def calculate_recipients
    emails = []
    emails << (@learner.personal_email.presence || @learner.institutional_email)

    # Only add parents if NOT UP program
    unless is_up_program?
      emails << @learner.parent1_email
      emails << @learner.parent2_email
    end

    emails.compact.uniq.map(&:to_s)
  end

  def calculate_cc
    lcs = @learner.learning_coaches.map(&:email)
    rm = @learner.hub&.regional_manager&.email
    list = (lcs + [rm]).compact
    list << "esther@bravegenerationacademy.com" if is_up_program?
    list.uniq
  end

  def is_up_program?
    @learner.curriculum_course_option.to_s.downcase.include?('up')
  end

  def template_name
    curriculum_raw = @learner.curriculum_course_option.to_s.downcase
    hub_type = @hub&.hub_type.to_s.downcase.gsub(' ', '_')

    if is_up_program?
      program = if curriculum_raw.include?('business') then 'business'
                elsif curriculum_raw.include?('computing') then 'computing'
                elsif curriculum_raw.include?('sports') then 'sports'
                end
      "onboarded_up_#{program}_#{hub_type}"
    else
      curriculum = curriculum_raw.gsub(' ', '_')
      "onboarded_#{curriculum}_#{hub_type}"
    end
  end

  def calculate_attachments
    files = []

    # 1. Authenticator
    files << { name: 'MicrosoftAuthenticator.pdf', path: 'public/documents/microsoft_authenticator.pdf' }

    # 2. Credentials (Dynamic Blob)
    credentials = @learner.learner_documents.find_by(document_type: 'credentials')
    if credentials&.file&.attached?
      files << {
        name: "Credentials_Document#{File.extname(credentials.file.filename.to_s)}",
        blob: credentials.file.blob
      }
    end

    # 3. Calendar (Logic extracted)
    unless @hub&.hub_type == "Powered by BGA"
      calendar = ['portugal', 'spain'].include?(@hub&.country&.downcase) ? 'calendar_2026_europe.pdf' : 'calendar_2026_africa.pdf'
      files << { name: 'Calendar.pdf', path: "public/documents/#{calendar}" }
    end

    # 4. Handbook/Billing (Logic extracted)
    curr = @learner.curriculum_course_option.to_s.downcase
    unless is_up_program?
      files << { name: 'Handbook.pdf', path: 'public/documents/handbook.pdf' } if %w(portuguese british own american).any? { |c| curr.include?(c) }
      files << { name: 'Billing_Guide.pdf', path: 'public/documents/billing_guide.pdf' } if curr.include?('portuguese')

      # Welcome Letter Generation
      if %w(british american own).any? { |c| curr.include?(c) }
        begin
          # Assuming WelcomeLetterGenerator returns binary data
          # We'll handle this generation in the mailer or here. simpler to pass the logic to mailer if it's complex generation
          files << { name: 'Welcome_Letter.pdf', generator: true }
        rescue => e
          Rails.logger.error("Welcome Letter Error: #{e.message}")
        end
      end
    end

    files
  end

  def mentor_details
    return {} unless is_up_program?

    curr = @learner.curriculum_course_option.to_s.downcase
    if curr.include?('business')
      if @learner.grade_year == 'Level 4'
        { name: "Rafael Escobar", email: "rafael.escobar@edubga.com" }
      else
        { name: "Vanessa Gomes", email: "vanessa.gomes@edubga.com" }
      end
    elsif curr.include?('computing')
      { name: "Cameron Dorning", email: "cameron.dorning@genexinstitute.com" }
    elsif curr.include?('sports')
      { name: "Aubrey Stout", email: "aubrey.stout@etacollege.com" }
    else
      {}
    end
  end
end
