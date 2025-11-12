# app/models/learner_info.rb
class LearnerInfo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :hub, optional: true
  belongs_to :learning_coach, class_name: 'User', optional: true
  has_many :learner_documents, dependent: :destroy
  has_many :learner_info_logs, dependent: :delete_all
  has_one :learner_finance, dependent: :destroy

  accepts_nested_attributes_for :learner_finance, update_only: true

  attr_accessor :skip_email_validation

  EMAIL_FIELDS = %w[
    personal_email
    institutional_email
    parent1_email
    parent2_email
    previous_school_email
  ].freeze

  # Curriculum mapping constants
  CURRICULUM_MAP = {
    'american curriculum (fia)' => 'American Curriculum',
    'british curriculum' => 'British Curriculum',
    'alternative (own) curriculum' => 'Own Curriculum',
    'up business' => 'UP Business',
    'american curriculum (ecampus)' => 'Own Curriculum',
    'up sports and leisure' => 'UP Sports Management',
    'unsure' => nil,
    'up computing' => 'UP Computing',
    'american curriculum (flvs)' => 'Own Curriculum',
    'up business (bga)' => 'UP Business',
    'esl course' => 'ESL Course',
    'portuguese curriculum' => 'Portuguese Curriculum',
    'american curriculum' => 'American Curriculum',
    'up business management' => 'UPx Business',
    'own curriculum' => 'Own Curriculum',
    'upx business management' => 'UPx Business',
    'up business ; upx business management' => 'UPx Business'
  }.freeze

  GRADES_PER_CURRICULUM = {
    "British Curriculum" => ["UK Year 13", "UK Year 12", "UK Year 11", "UK Year 10", "UK Year 9", "UK Year 8"],
    "American Curriculum" => ["US Year 12", "US Year 11", "US Year 10", "US Year 9", "US Year 8", "US Year 7", "US Year 6", "US Year 5"],
    "Portuguese Curriculum" => ["PT Year 12", "PT Year 11", "PT Year 10", "PT Year 9", "PT Year 8", "PT Year 7"],
    "Own Curriculum" => ["N/A"],
    "ESL Course" => ["N/A"],
    "UP Business" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UPx Business" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Sports Management" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Sports Exercise" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Computing" => ["Level 3", "Level 4", "Level 5", "Level 6"]
  }.freeze

  # Grade conversion mappings
  US_TO_UK_GRADE_MAP = {
    12 => 13, 11 => 12, 10 => 11, 9 => 10, 8 => 9, 7 => 8
  }.freeze

  UK_TO_US_GRADE_MAP = {
    13 => 12, 12 => 11, 11 => 10, 10 => 9, 9 => 8, 8 => 7
  }.freeze

  US_TO_PT_GRADE_MAP = US_TO_UK_GRADE_MAP # PT follows similar pattern to UK

  US_TO_LEVEL_MAP = {
    12 => 6, 11 => 5, 10 => 4, 9 => 3
  }.freeze

  INACTIVE_STATUSES = %w[Waitlist Waitlist\ -\ ok In\ progress\ conditional Inactive Graduated].freeze

  scope :active, -> { where.not(status: INACTIVE_STATUSES) }

  before_validation :normalize_emails
  before_validation :normalize_curriculum
  before_validation :normalize_grade

  after_commit :check_status_updates, on: [:create, :update]
  after_commit :update_discounts_if_needed, on: [:create, :update]
  after_update :send_end_date_notifications, if: :saved_change_to_end_date?

  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates *EMAIL_FIELDS.map(&:to_sym),
            format: { with: VALID_EMAIL_REGEX, message: "is not a valid email" },
            allow_blank: true,
            unless: :skip_email_validation

  # Class methods for normalization (can be used independently)
  class << self
    def normalize_curriculum_value(raw_curriculum)
      return nil if raw_curriculum.nil? || raw_curriculum.to_s.strip.empty?

      normalized_key = raw_curriculum.to_s.strip.downcase
      mapped = CURRICULUM_MAP[normalized_key]

      return mapped if mapped || CURRICULUM_MAP.key?(normalized_key)

      # Fallback patterns
      if normalized_key.include?('upx') && normalized_key.include?('business')
        return 'UPx Business'
      elsif normalized_key.include?('up') && normalized_key.include?('business')
        return 'UP Business'
      elsif normalized_key.include?('ecampus') || normalized_key.include?('flvs')
        return 'Own Curriculum'
      end

      # Return original if no mapping found
      raw_curriculum.to_s.strip
    end

    def normalize_grade_value(raw_grade, curriculum)
      return nil if raw_grade.nil? || raw_grade.to_s.strip.empty?
      return nil if curriculum.nil?

      grade_str = raw_grade.to_s.strip

      # Extract year/grade numbers from various formats
      us_match = grade_str.match(/US\s+(?:Grade|Year)\s+(\d+)/i)
      uk_match = grade_str.match(/UK\s+Year\s+(\d+)/i)
      pt_match = grade_str.match(/PT\s+Year\s+(\d+)/i)
      level_match = grade_str.match(/Level\s+(\d+)/i)
      simple_number = grade_str.match(/^\d+$/) ? grade_str.to_i : nil

      case curriculum
      when 'British Curriculum'
        if uk_match
          "UK Year #{uk_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          uk_year = US_TO_UK_GRADE_MAP[us_grade] || us_grade
          "UK Year #{uk_year}"
        elsif simple_number
          "UK Year #{simple_number}"
        else
          raw_grade
        end

      when 'American Curriculum'
        if us_match
          "US Year #{us_match[1].to_i}"
        elsif uk_match
          uk_year = uk_match[1].to_i
          us_grade = UK_TO_US_GRADE_MAP[uk_year] || uk_year
          "US Year #{us_grade}"
        elsif simple_number
          "US Year #{simple_number}"
        else
          raw_grade
        end

      when 'Portuguese Curriculum'
        if pt_match
          "PT Year #{pt_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          pt_year = US_TO_PT_GRADE_MAP[us_grade] || us_grade
          "PT Year #{pt_year}"
        elsif simple_number
          "PT Year #{simple_number}"
        else
          raw_grade
        end

      when 'UP Business', 'UPx Business', 'UP Computing', 'UP Sports Management', 'UP Sports Exercise'
        if level_match
          "Level #{level_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          level = US_TO_LEVEL_MAP[us_grade]
          level ? "Level #{level}" : raw_grade
        elsif simple_number && simple_number >= 3 && simple_number <= 6
          "Level #{simple_number}"
        else
          raw_grade
        end

      when 'Own Curriculum', 'ESL Course'
        nil

      else
        raw_grade
      end
    end

    # Calculate grade from HubSpot format (e.g., "Year 11 (grade 10) - IGCSEs")
    def calculate_grade_from_hubspot(raw_grade_string, curriculum)
      return nil if curriculum.nil? || raw_grade_string.nil? || raw_grade_string.strip.empty?

      # Clean the grade string: "Year 11 (grade 10) - IGCSEs" -> "Year 11 (grade 10)"
      cleaned_grade_string = raw_grade_string.split(' - ').first.to_s.strip

      # Extract the year number (e.g., "Year 11 (grade 10)" -> 11)
      match = cleaned_grade_string.match(/Year\s*(\d+)/i)
      base_year = match ? match[1].to_i : nil

      return nil if base_year.nil?

      # UP courses, Own, and ESL use first level/value
      if curriculum.include?("UP") || ["Own Curriculum", "ESL Course"].include?(curriculum)
        return GRADES_PER_CURRICULUM[curriculum]&.first
      end

      # Calculate final year based on curriculum
      final_year = base_year
      prefix = ''

      case curriculum
      when "British Curriculum"
        prefix = 'UK Year '
      when "American Curriculum"
        final_year -= 1 unless final_year.zero?
        prefix = 'US Year '
      when "Portuguese Curriculum"
        final_year -= 1 unless final_year.zero?
        prefix = 'PT Year '
      else
        Rails.logger.warn("Unhandled curriculum in HubSpot calculation: #{curriculum}")
        prefix = 'Unknown Year '
      end

      "#{prefix}#{final_year}"
    end
  end

  def log_update(by_user = nil, saved_changes_hash = nil, note: nil)
    saved_changes_hash ||= saved_changes
    return if saved_changes_hash.blank?

    ignore_keys = %w[updated_at]
    changes = saved_changes_hash.except(*ignore_keys)

    return if changes.blank?

    changed_fields = changes.keys.map(&:to_s)
    changed_data = changes.transform_values { |v| { 'from' => v[0], 'to' => v[1] } }

    learner_info_logs.create!(
      user: by_user,
      action: 'update',
      changed_fields: changed_fields,
      changed_data: changed_data,
      note: note
    )
  end

  def institutional_email_prefix
    institutional_email.to_s.split('@').first || ''
  end

  def institutional_email_prefix=(prefix)
    self.institutional_email = prefix.present? ? "#{prefix.strip.downcase}@edubga.com" : nil
  end

  def check_status_updates
    new_status = calculate_status
    return if new_status == status && !saved_change_to_status?

    old_status = status
    if new_status == "Onboarded" && student_number.blank?
      gen_number = generate_student_number
      update_columns(status: new_status, student_number: gen_number)
      log_update(nil, { 'status' => [old_status, new_status], 'student_number' => [nil, gen_number] }, note: "Automated status update to #{new_status} with student number generation")
    else
      update_column(:status, new_status)
      log_update(nil, { 'status' => [old_status, new_status] }, note: "Automated status update to #{new_status}")
    end

    if new_status == "In progress" && old_status == "In progress conditional"
      create_institutional_user_if_needed
    end

    send_status_notification(new_status)
  end

  def calculate_status
    learner_documents.reload

    has_notes = onboarding_meeting_notes.present?
    has_contract = learner_documents.exists?(document_type: 'contract')
    has_proof = learner_documents.exists?(document_type: 'proof_of_payment')
    has_documents = has_contract && has_proof
    has_credentials = learner_documents.exists?(document_type: 'credentials') || !curriculum_course_option.to_s.strip.downcase.start_with?('up')
    has_start_date = start_date.present?
    has_started = has_start_date && start_date <= Date.today
    end_date_passed = end_date.present? && end_date < Date.today
    is_up_curriculum = curriculum_course_option.to_s.strip.downcase.start_with?('up')
    has_platform_info = platform_username.present? && platform_password.present?

    case status
      when "Inactive"
        if !end_date_passed && has_active_account
          "Active"
        else
          "Inactive"
        end
      when "Active"
        if end_date_passed
          "Inactive"
        elsif !has_started && has_start_date
          has_credentials ? "Onboarded" : "Validated"
        elsif !has_started && !has_start_date
          "Validated"
        else
          "Active"
        end
      when "Onboarded"
        if has_started
          "Active"
        elsif !has_start_date || !has_platform_info || !has_credentials
          "Validated"
        else
          "Onboarded"
        end
      when "Validated"
        if has_start_date && has_platform_info && has_credentials
          "Onboarded"
        elsif !has_documents
          if is_up_curriculum
            status_was_waitlist_ok? ? "Waitlist" : "In progress"
          else
            status_was_waitlist_ok? ? "Waitlist - ok" : "In progress - ok"
          end
        else
          "Validated"
        end
      when "In progress - ok"
        if is_up_curriculum
          if has_documents
            "Validated"
          else
            "In progress"
          end
        elsif !has_notes
          "In progress"
        elsif has_documents
          "Validated"
        else
          "In progress - ok"
        end
      when "Waitlist - ok"
        if !has_notes
          "Waitlist"
        else
          "Waitlist - ok"
        end
      when "In progress"
        if !data_validated
          "In progress conditional"
        else
          if is_up_curriculum
            has_documents ? "Validated" : "In progress"
          else
            has_notes ? "In progress - ok" : "In progress"
          end
        end
      when "In progress conditional"
        data_validated ? "In progress" : "In progress conditional"
      when "Waitlist"
        has_notes ? "Waitlist - ok" : "Waitlist"
      else
        status # Fallback for new or unknown
    end
  end

  def learning_coaches
    prog = programme.to_s.strip.downcase
    case prog
    when 'online'
      [learning_coach].compact
    when 'hybrid'
      hub ? hub.learning_coaches.to_a : []
    else
      []
    end
  end

  def admissions_users
    [User.find_by(email: 'guilherme@bravegenerationacademy.com')].compact #[User.find_by(email: "admissions@bravegenerationacademy.com")].compact
  end

  def finance_users
    [User.find_by(email: "maria.m@bravegenerationacademy.com")].compact
  end

  def curriculum_responsibles
    curr = curriculum_course_option.to_s.strip.downcase
    case
    when curr.include?('portuguese')
      User.where(email: ['luis@bravegenerationacademy.com', 'goncalo.meireles@edubga.com']).to_a
    when curr.start_with?('up')
      [User.find_by(email: 'guilherme@bravegenerationacademy.com')].compact # [User.find_by(email: 'esther@bravegenerationacademy.com')].compact
    else
      [User.find_by(email: 'danielle@bravegenerationacademy.com')].compact
    end
  end

  def regional_manager
    return [] unless hub && hub.respond_to?(:regional_manager) && hub.regional_manager.present?
    [hub.regional_manager]
  end

  def active?
    !INACTIVE_STATUSES.include?(status)
  end

  def siblings
    return [] unless parent1_email.present? || parent2_email.present?

    siblings_query = LearnerInfo.where.not(id: id)

    or_conditions = []
    [parent1_email, parent2_email].compact.uniq.each do |email|
      or_conditions << "parent1_email = '#{email}' OR parent2_email = '#{email}'"
    end

    siblings_query = siblings_query.where(or_conditions.join(' OR '))

    siblings_query.distinct
  end

  def family
    [self] + siblings
  end

  def update_family_discounts
    active_family = family.select(&:active?)
    count = active_family.size

    discount = case count
               when 0..1 then 0.0
               when 2 then 5.0
               else 7.5
               end

    active_family.each do |learner|
      finance = learner.learner_finance
      next unless finance

      if finance.discount_mf != discount
        old_discount = finance.discount_mf
        finance.update!(discount_mf: discount)
        learner.log_update(nil, { 'learner_finance.discount_mf' => [old_discount, discount] }, note: "Updated sibling discount based on family size #{count}")
        Rails.logger.info("Updated discount_mf for LearnerInfo ID: #{learner.id} to #{discount}% (family active count: #{count})")
      end
    end
  end

  def update_discounts_if_needed
    if saved_change_to_status? || saved_change_to_parent1_email? || saved_change_to_parent2_email?
      update_family_discounts
    end
  end

  def notify_recipients(recipient, message, link: nil)
    recipients = Array.wrap(recipient)
    raise ArgumentError, "message is required" if message.blank?

    link ||= Rails.application.routes.url_helpers.admission_path(self)

    if recipients.blank?
      Rails.logger.warn("[LearnerInfo##{id}] No recipients found for notification; none created.")
      return
    end

    recipients.each do |user|
      Notification.create!(user: user, message: message, link: link, read: false)
    end

    Rails.logger.info("[LearnerInfo##{id}] Created notifications for #{recipients.size} recipient(s). Message: #{message}")
  end

  def send_end_date_notifications
    return unless end_date.present?

    message = "End date has been set for learner #{full_name} to #{end_date.strftime('%d-%m-%Y')}."
    notify_recipients(finance_users, message)

    # TO DO: Schedule reminder if more than 1 month away
  end

  def send_status_notification(new_status)
    case new_status
    when "In progress conditional"
      curr = curriculum_course_option.to_s.strip.downcase
      link = Rails.application.routes.url_helpers.admission_url(self)

      if curr.start_with?('up')
        responsible = curriculum_responsibles
        message = "New enrolment for UP. Please validate the data please. Check profile here: #{link}"
        subject = "New Enrolment for UP"

        responsible.each do |user|
          UserMailer.admissions_notification(user, message, subject).deliver_now
        end

        Rails.logger.info("[LearnerInfo##{id}] Sent UP enrolment email notification to #{responsible.size} curriculum responsible(s).")
      else
        message = "New Learner has filled the application forms."
        notify_recipients(admissions_users, message)
      end
    when "In progress"
      message = "#{full_name} is enrolling for: #{hub&.name}. Check the profile on the link."
      notify_recipients(learning_coaches + finance_users, message)

      curr = curriculum_course_option.to_s.strip.downcase
      link = Rails.application.routes.url_helpers.admission_url(self)

      if curr.start_with?('up')
        adm_message = "New learner for UP has been validated. Check Profile here: #{link}"
        subject = "New Learner for UP Validated"

        notify_recipients(admissions_users, adm_message)

        admissions_users.each do |user|
          UserMailer.admissions_notification(user, adm_message, subject).deliver_now
        end

        Rails.logger.info("[LearnerInfo##{id}] Sent UP validation notification and email to #{admissions_users.size} admissions user(s).")
      else
        curr_message = "#{full_name} is ready for onboarding process. Check the profile on the link."
        notify_recipients(curriculum_responsibles, curr_message)
      end

      rm_message = "#{full_name} is enrolling for: #{hub&.name}."
      notify_recipients(regional_manager, rm_message)
    when "In progress - ok"
      message = "#{full_name} had the onboarding meeting. Check here."
      notify_recipients(learning_coaches + regional_manager, message)

      link = Rails.application.routes.url_helpers.admission_url(self)
      adm_message = "The learner #{full_name} had the onboarding meeting today. Check his profile here: #{link}"
      adm_subject = "#{full_name} had the onboarding meeting"

      admissions_users.each do |user|
        # TO DO: CHANGE TO ADMISSION USERS
        UserMailer.admissions_notification(User.find_by(email: "guilherme@bravegenerationacademy.com"), adm_message, adm_subject).deliver_now
      end
    when "Validated"
      # send_teams_message
    when "Onboarded"
      message = "#{full_name} is ready to roll at #{start_date}"
      notify_recipients(learning_coaches + curriculum_responsibles + regional_manager, message)

      # Send email to parents based on curriculum and hub type
      UserMailer.onboarding_email(self).deliver_now
    when "Inactive"
      # Notify finance users when a learner becomes Inactive
      message = "#{full_name} status has been changed to Inactive."
      notify_recipients(finance_users, message)
    end
  end

  def self.sync_date_based_statuses!(run_at: Time.current)
    today = run_at.to_date

    # Find candidates for activation
    activation_candidates = where(status: "Onboarded")
                            .where("start_date IS NOT NULL AND start_date <= ?", today)

    # Find candidates for inactivation
    inactivation_candidates = where(status: "Active")
                              .where("end_date IS NOT NULL AND end_date < ?", today)

    # Find candidates for user account activation (start date within next 15 days)
    user_activation_candidates = where(status: "Onboarded")
                                .where("start_date IS NOT NULL AND start_date > ? AND start_date <= ?", today, today + 15)

    # Combine and dedupe
    candidates = (activation_candidates + inactivation_candidates + user_activation_candidates).uniq

    updated_count = 0
    user_activated_count = 0

    candidates.each do |learner|
      learner.check_status_updates
      updated_count += 1 if learner.saved_change_to_status?

      # Activate user account if start date is within 15 days and user is deactivated
      if learner.user && learner.start_date && (today + 1..today + 15).cover?(learner.start_date) && learner.user.deactivate
        learner.user.update(deactivate: false)
        user_activated_count += 1
      end
    end

    Rails.logger.info(
      "[LearnerInfo.sync_date_based_statuses!] Processed #{candidates.size} candidates – #{updated_count} statuses synced (activations/inactivations), #{user_activated_count} user accounts activated."
    )

    { updated_statuses: updated_count, activated_users: user_activated_count }
  end

  private

  def status_was_waitlist_ok?
    # Helper to infer path for revert; can be improved with a persisted path flag if needed
    previous_changes[:status]&.first&.include?("Waitlist") || false
  end

  def generate_student_number
    year = Time.current.year
    min_sn = year * 10000
    max_sn = min_sn + 9999
    max_existing = LearnerInfo.where(student_number: min_sn..max_sn).maximum(:student_number)
    if max_existing.nil?
      min_sn + 1
    else
      max_existing + 1
    end
  end

  def create_institutional_user_if_needed
    return if institutional_email.present? || user.present?

    # Generate institutional_email: firstname.lastname@edubga.com using first and last name only
    names = full_name.to_s.strip.split(/\s+/)
    return unless names.size >= 2

    first_name = I18n.transliterate(names.first).downcase
    last_name = I18n.transliterate(names.last).downcase
    generated_email = "#{first_name}.#{last_name}@edubga.com"
    counter = 1
    while User.exists?(email: generated_email)
      generated_email = "#{first_name}.#{last_name}#{counter}@edubga.com"
      counter += 1
    end

    begin
      # Create User
      new_user = User.create!(
        full_name: full_name,
        email: generated_email,
        password: "123456",
        password_confirmation: "123456",
        role: 'learner',
        deactivate: true,
        confirmed_at: Time.now
      )

      # Associate user
      update_column(:user_id, new_user.id)
      update_column(:institutional_email, generated_email)

      # Associate with hub via users_hubs (if hub exists)
      if hub_id.present?
        UsersHub.create!(user_id: new_user.id, hub_id: hub_id)
        Rails.logger.info("[LearnerInfo##{id}] Associated new user #{new_user.id} with hub #{hub_id} via users_hubs.")
      end

      # Log the creation
      log_update(nil, { 'institutional_email' => [nil, generated_email], 'user_id' => [nil, new_user.id] }, note: "Created institutional user on data validation")
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("[LearnerInfo##{id}] Failed to create institutional user: #{e.message}")
      # Optionally rollback or notify
    end
  end

  def normalize_emails
    EMAIL_FIELDS.each do |attr|
      next unless (val = self[attr]).present?
      self[attr] = val.strip.downcase
    end
  end

  def normalize_curriculum
    return unless curriculum_course_option_changed? && curriculum_course_option.present?

    old_value = curriculum_course_option
    normalized = self.class.normalize_curriculum_value(old_value)

    if normalized != old_value
      self.curriculum_course_option = normalized
      Rails.logger.info("Normalized curriculum: #{old_value.inspect} -> #{normalized.inspect}")
    end
  end

  def normalize_grade
    return unless (grade_year_changed? || curriculum_course_option_changed?) &&
                  grade_year.present? && curriculum_course_option.present?

    old_value = grade_year
    normalized = self.class.normalize_grade_value(old_value, curriculum_course_option)

    if normalized != old_value
      self.grade_year = normalized
      Rails.logger.info("Normalized grade: #{old_value.inspect} -> #{normalized.inspect} (curriculum: #{curriculum_course_option})")
    end
  end

  def send_teams_message
    # 1. Prepare data for the Adaptive Card "FactSet"
    facts = [
      { "title": "Learner's Full Name", "value": self.full_name },
      { "title": "Learner's Email", "value": self.personal_email },
      { "title": "Learner's Level", "value": self.grade_year },
      { "title": "Curriculum", "value": self.curriculum_course_option },
      { "title": "Hub Location", "value": self.hub&.name } # Use safe navigation (&.) for hub
    ]

    # 2. Build the full Adaptive Card JSON structure
    payload = build_adaptive_card_payload(facts)

    # 3. Post the payload to the Teams webhook URL
    post_to_teams_webhook(ENV['TEAMS_WEBHOOK'], payload)
  end

  # Helper method to construct the required Adaptive Card JSON
  def build_adaptive_card_payload(facts)
    {
      "type": "message",
      "attachments": [
        {
          "contentType": "application/vnd.microsoft.card.adaptive",
          "content": {
            "type": "AdaptiveCard",
            "body": [
              {
                "type": "TextBlock",
                "text": "✅ Learner Data Validation Complete!",
                "size": "large",
                "weight": "bolder"
              },
              {
                "type": "TextBlock",
                "text": "The learner is now ready for the next step in the enrollment process.",
                "wrap": true
              },
              {
                "type": "FactSet",
                "facts": facts
              }
            ],
            "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
            "version": "1.2"
          }
        }
      ]
    }.to_json
  end

  # Generic method to handle the HTTP POST request
  def post_to_teams_webhook(url, json_payload)
    uri = URI(url)

    # Use a background job (like Sidekiq) for real apps to prevent blocking
    # For a direct example, we'll use synchronous Net::HTTP
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = json_payload

    response = http.request(request)

    # Basic logging for success/failure
    Rails.logger.info "Teams Webhook Response: #{response.code} #{response.message}"

    # You may want to add error handling logic here (e.g., retries on 500/429 status codes)
    response.is_a?(Net::HTTPSuccess)
  end
end
