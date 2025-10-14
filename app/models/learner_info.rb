class LearnerInfo < ApplicationRecord
  belongs_to :user, optional: true
  has_many :learner_documents, dependent: :destroy
  has_many :learner_info_logs, dependent: :delete_all
  has_one :learner_finance, dependent: :destroy

  # validate user needs to be learner?

  EMAIL_FIELDS = %w[
    personal_email
    institutional_email
    parent1_email
    parent2_email
    previous_school_email
  ].freeze

  before_validation :normalize_emails

  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates *EMAIL_FIELDS.map(&:to_sym),
            format: { with: VALID_EMAIL_REGEX, message: "is not a valid email" },
            allow_blank: true

  def log_update(by_user = nil, saved_changes_hash = nil, note: nil)
    saved_changes_hash ||= saved_changes
    return if saved_changes_hash.blank?

    # ignore non-user-facing changes
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

  private

  def normalize_emails
    EMAIL_FIELDS.each do |attr|
      next unless (val = self[attr]).present?
      self[attr] = val.strip.downcase
    end
  end
end
