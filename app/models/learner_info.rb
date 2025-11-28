# TO DO: REFACTOR
# ADD CONCERNS FOR NORMALIZATION, NOTIFICATIONS, FINANCES
# MAYBE EXTRACT STATUS LOGIC TO A SERVICE?
# CREATE INSTITUTIONAL USER ALSO CAN GO TO A SERVICE?
# SEND MESSAGE TEAMS TO A JOB?
class LearnerInfo < ApplicationRecord
  include LearnerNormalization
  include LearnerNotifications

  belongs_to :user, optional: true
  belongs_to :hub, optional: true
  belongs_to :learning_coach, class_name: 'User', optional: true

  has_many :learner_documents, dependent: :destroy
  has_many :learner_info_logs, dependent: :delete_all
  has_one :learner_finance, dependent: :destroy

  accepts_nested_attributes_for :learner_finance, update_only: true

  attr_accessor :skip_email_validation

  INACTIVE_STATUSES = %w[Waitlist Waitlist\ -\ ok In\ progress\ conditional Inactive Graduated].freeze
  scope :active, -> { where.not(status: INACTIVE_STATUSES) }

  after_commit :check_status_updates, on: :update
  after_commit :update_discounts_if_needed, on: [:create, :update]
  after_commit :check_date_updates, on: :update

  validates *LearnerNormalization::EMAIL_FIELDS.map(&:to_sym),
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" },
            allow_blank: true,
            unless: :skip_email_validation

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
    changes = { 'status' => [old_status, new_status] }

    attributes_to_update = { status: new_status }

    if new_status == "Onboarded" && student_number.blank?
      gen_number = generate_student_number
      self.student_number = gen_number
      changes['student_number'] = [nil, gen_number]
      attributes_to_update[:student_number] = gen_number
    end

    update_columns(attributes_to_update)
    self.status = new_status

    log_update(nil, changes, note: "Automated status update to #{new_status}" + (gen_number ? " with student number generation" : ""))

    send_status_notification(new_status)
  end

  def calculate_status
    learner_documents.reload

    has_notes = onboarding_meeting_notes.present?
    has_contract = learner_documents.exists?(document_type: 'contract')
    has_proof = learner_documents.exists?(document_type: 'proof_of_payment')
    has_documents = has_contract && has_proof
    has_credentials = learner_documents.exists?(document_type: 'credentials')
    has_institutional_email = institutional_email.present?
    has_start_date = start_date.present?
    has_started = has_start_date && start_date <= Date.today
    end_date_passed = end_date.present? && end_date < Date.today
    is_up_curriculum = curriculum_course_option.to_s.strip.downcase.start_with?('up')
    is_american_curriculum = curriculum_course_option.to_s.strip.downcase.start_with?('america')
    has_platform_info = is_american_curriculum || (platform_username.present? && platform_password.present?)
    has_lc = learning_coaches.count.positive?

    case status
      when "Inactive"
        if !end_date_passed
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
        elsif !has_start_date || !has_platform_info || !has_credentials || !has_institutional_email
          "Validated"
        else
          "Onboarded"
        end
      when "Validated"
        if has_start_date && has_platform_info && has_credentials && has_institutional_email
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
        (data_validated && has_lc) ? "In progress" : "In progress conditional"
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
      hub ? hub.learning_coaches_with_capacity.to_a : []
    else
      []
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

  def check_date_updates
    if saved_change_to_start_date? || saved_change_to_end_date?

      parts = []
      if saved_change_to_start_date?
        parts << "Start Date changed to #{start_date&.strftime('%d-%m-%Y')}"
      end
      if saved_change_to_end_date?
        parts << "End Date changed to #{end_date&.strftime('%d-%m-%Y')}"
      end

      message = "Date updates for #{full_name}: #{parts.join(', ')}."

      notify_recipients(self.class.finance_users, message)
    end
  end

  def send_status_notification(new_status)
    case new_status
    when "In progress conditional"
      curr = curriculum_course_option.to_s.strip.downcase
      link = Rails.application.routes.url_helpers.admission_url(self)

      if curr.start_with?('up')
        responsible = self.class.curriculum_responsibles(self.curriculum_course_option)
        message = "New enrolment for UP. Please validate the data please. Check profile here: <a href='#{link}' target='_blank' rel='noopener'>#{link}</a>"
        subject = "New Enrolment for UP"

        responsible.each do |user|
          UserMailer.admissions_notification(user, message, subject).deliver_now
        end

        Rails.logger.info("[LearnerInfo##{id}] Sent UP enrolment email notification to #{responsible.size} curriculum responsible(s).")
      else
        message = "New Learner (#{full_name}) has filled the application forms."
        notify_recipients(self.class.admissions_users, message)
      end
    when "In progress"
      message = "#{full_name} is enrolling for: #{hub&.name}. Check the profile on the link."
      notify_recipients(learning_coaches + self.class.finance_users, message)

      curr = curriculum_course_option.to_s.strip.downcase
      link = Rails.application.routes.url_helpers.admission_url(self)

      if curr.start_with?('up')
        adm_message = "New learner (#{full_name}) for UP has been validated. Check Profile here: #{link}"
        subject = "New Learner (#{full_name}) for UP Validated"

        notify_recipients(self.class.admissions_users, adm_message)

        self.class.admissions_users.each do |user|
          UserMailer.admissions_notification(user, adm_message, subject).deliver_now
        end

        Rails.logger.info("[LearnerInfo##{id}] Sent UP validation notification and email to #{self.class.admissions_users.size} admissions user(s).")
      else
        curr_message = "#{full_name} is ready for onboarding process. Check the profile on the link."
        notify_recipients(self.class.curriculum_responsibles(self.curriculum_course_option), curr_message)
      end

      rm_message = "#{full_name} is enrolling for: #{hub&.name}."
      notify_recipients(regional_manager, rm_message)
    when "In progress - ok"
      message = "#{full_name} had the onboarding meeting. Check here."
      notify_recipients(learning_coaches + regional_manager + self.class.finance_users, message)

      link = Rails.application.routes.url_helpers.admission_url(self)
      adm_message = "The learner #{full_name} had the onboarding meeting today. Check his profile here: #{link}"
      adm_subject = "#{full_name} had the onboarding meeting"

      self.class.admissions_users.each do |user|
        UserMailer.admissions_notification(user, adm_message, adm_subject).deliver_now
      end
    when "Validated"
      send_teams_message
    when "Onboarded"
      message = "#{full_name} is ready to roll at #{start_date}"
      notify_recipients(learning_coaches + self.class.curriculum_responsibles(self.curriculum_course_option) + regional_manager, message)
    when "Inactive"
      # Notify finance users when a learner becomes Inactive
      message = "#{full_name} status has been changed to Inactive."
      notify_recipients(self.class.finance_users, message)

      lc_message = "#{full_name} has become Inactive. Please ensure the parents are removed from the WhatsApp group."
      notify_recipients(learning_coaches, lc_message)
    end
  end

  def self.perform_daily_maintenance!(run_at: Time.current)
    today = run_at.to_date
    Rails.logger.info "[DailyMaintenance] Starting maintenance for #{today}..."

    # 1. Sync with external services
    sync_hubspot_submissions

    # 2. Update Statuses (Onboarded -> Active, Active -> Inactive)
    sync_learner_statuses!(today)

    # 3. Activate User Accounts (Access preparation)
    activate_upcoming_users!(today)

    # 4. Send Emails
    send_onboarding_emails!(today)
    # send_renewal_reminders!(today)

    Rails.logger.info "[DailyMaintenance] Completed."
  end

  def self.check_hub_capacity_and_notify!(inactivated_learners = [])
    return if inactivated_learners.blank?

    affected_hubs = inactivated_learners.map(&:hub).compact.uniq

    affected_hubs.each do |hub|
      next unless hub.free_spots && hub.free_spots > 0

      waitlisted_learners = LearnerInfo.where(hub_id: hub.id, status: ["Waitlist", "Waitlist - ok"])
      next if waitlisted_learners.none?

      message = "Hub #{hub.name} now has #{hub.free_spots} free spots available after recent deactivations. There are #{waitlisted_learners.count} learners on the waitlist for this hub. Please review and process as needed."
      notify_recipients(self.class.admissions_users, message)

      Rails.logger.info("[Hub##{hub.id}] Notified #{admissions_users.size} admissions users about available capacity and waitlist.")
    end
  end

  def ensure_worktools_accounts!
    ActiveRecord::Base.transaction do
      create_or_link_learner_user!
      sync_parents_with_kids!
    end
  rescue => e
    Rails.logger.error "[LearnerInfo##{id}] Failed to ensure Worktools accounts: #{e.message}"
    raise if Rails.env.development?
  end

  private

  def create_or_link_learner_user!
    return if user.present?

    email = institutional_email.strip.downcase
    existing_user = User.find_by(email: email)

    if existing_user
      update_column(:user_id, existing_user.id)
      return
    end

    new_user = User.create!(
      full_name: full_name,
      email: email,
      password: platform_password,
      password_confirmation: platform_password,
      role: "learner",
      confirmed_at: Time.current,
      deactivate: false
    )

    LearnerFlag.create!(
          user_id: new_user.id,
          asks_for_help: false,
          takes_notes: false,
          goes_to_live_lessons: false,
          does_p2p: false,
          action_plan: "",
          life_experiences: false
    )

    # Link back
    update_column(:user_id, new_user.id)

    # Associate with hub if present
    if hub_id.present?
      UsersHub.find_or_create_by!(user: new_user, hub_id: hub_id, main: true)
    end

    Rails.logger.info "[LearnerInfo##{id}] Created learner User: #{email}"
  end

  def sync_parents_with_kids!
    kid_user = user
    return unless kid_user

    return if kid_user.deactivate?

    password = platform_password

    [
      { name: parent1_full_name, email: parent1_email },
      { name: parent2_full_name, email: parent2_email }
    ].each do |data|
      email = data[:email]&.strip&.downcase
      next if email.blank?

      full_name = data[:name]&.strip.presence || email.split("@").first.humanize

      parent = User.find_or_initialize_by(email: email)
      parent.assign_attributes(
        full_name: full_name,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.current,
        role: "Parent"
      )

      # Temporarily bypass email domain validation
      parent.define_singleton_method(:email_domain_check) { true } if parent.new_record?

      if parent.save
        unless parent.kids.include?(kid_user)
          parent.kids << kid_user.id if kid_user && !parent.kids.include?(kid_user.id)
          parent.save!
          Rails.logger.info "[LearnerInfo##{id}] Linked parent #{email} to kid #{kid_user.email}"
        end
      else
        Rails.logger.warn "[LearnerInfo##{id}] Failed to save parent #{email}: #{parent.errors.full_messages}"
      end
    end
  end

  def self.sync_hubspot_submissions
    Rails.logger.info "[DailyMaintenance] Fetching HubSpot submissions..."
    HubspotService.fetch_new_submissions
  rescue StandardError => e
    Rails.logger.error "[DailyMaintenance] HubSpot Sync Failed: #{e.message}"
  end

  def self.sync_learner_statuses!(today)
    updated_count = 0
    inactivated_learners = []

    candidates = where(status: "Onboarded").where("start_date <= ?", today)
                 .or(where(status: "Active").where("end_date < ?", today))

    candidates.find_each do |learner|
      previous_status = learner.status
      learner.check_status_updates

      if learner.saved_change_to_status?
        updated_count += 1

        # Track Inactivations for notification
        if learner.status == "Inactive" && previous_status != "Inactive"
          inactivated_learners << learner
        end
      end
    end

    check_hub_capacity_and_notify!(inactivated_learners) if inactivated_learners.any?
    Rails.logger.info "[DailyMaintenance] Statuses synced: #{updated_count}. Inactivated: #{inactivated_learners.count}"
  end

  def self.activate_upcoming_users!(today)
    candidates = where(status: "Onboarded")
                 .where(start_date: (today + 1.day)..(today + 15.days))
                 .joins(:user)
                 .where(users: { deactivate: true })

    count = 0
    candidates.find_each do |learner|
      learner.user.update(deactivate: false)
      count += 1
    end
    Rails.logger.info "[DailyMaintenance] Users activated: #{count}"
  end

  def self.send_onboarding_emails!(today)
    # Find Onboarded learners starting in next 7 days who haven't received the email
    candidates = where(status: "Onboarded", onboarding_email_sent: false)
                 .where(start_date: (today + 1.day)..(today + 7.days))

    count = 0
    candidates.find_each do |learner|
      learner.ensure_worktools_accounts!
      UserMailer.onboarding_email(learner).deliver_now
      learner.update(onboarding_email_sent: true)
      count += 1
    end
    Rails.logger.info "[DailyMaintenance] Onboarding emails sent: #{count}"
  end

  def self.send_renewal_reminders!(today)
    target_month = (today + 1.month).month
    target_day   = today.day

    candidates = where(status: "Active").where("extract(day from start_date) = ?", target_day)

    count = 0
    candidates.find_each do |learner|
      if learner.start_date.month == target_month
        UserMailer.renewal_fee_email(learner).deliver_now
        count += 1
      end
    end
    Rails.logger.info "[DailyMaintenance] Renewal emails sent: #{count}"
  end

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

      LearnerFlag.create!(
          user_id: new_user.id,
          asks_for_help: false,
          takes_notes: false,
          goes_to_live_lessons: false,
          does_p2p: false,
          action_plan: "",
          life_experiences: false
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
