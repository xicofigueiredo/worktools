class LearnerFinance < ApplicationRecord
  belongs_to :learner_info

  validates :admission_fee, :monthly_fee, :renewal_fee,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :discount_mf, :scholarship, :discount_af, :discount_rf,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }

  after_create :notify_finance_created
  after_update :send_pricing_change_notification, if: :pricing_changed?

  before_save :calculate_billable_amounts

  private

  def calculate_billable_amounts
    if monthly_fee.present?
      discount_percent = ((discount_mf || 0) + (scholarship || 0)) / 100.0
      self.billable_mf = [monthly_fee * (1 - discount_percent), 0].max
    end

    if admission_fee.present?
      discount_percent = (discount_af || 0) / 100.0
      self.billable_af = [admission_fee * (1 - discount_percent), 0].max
    end

    if renewal_fee.present?
      discount_percent = (discount_rf || 0) / 100.0
      self.billable_rf = [renewal_fee * (1 - discount_percent), 0].max
    end
  end

  def pricing_changed?
    saved_change_to_discount_mf? ||
    saved_change_to_scholarship? ||
    saved_change_to_discount_af? ||
    saved_change_to_discount_rf? ||
    saved_change_to_monthly_fee? ||
    saved_change_to_admission_fee? ||
    saved_change_to_renewal_fee?
  end

  def send_pricing_change_notification
    return unless learner_info.present?
    allowed_statuses = %w[In progress conditional In progress In progress - ok Waitlist Waitlist - ok Validated Onboarded]
    return unless learner_info.status.in?(allowed_statuses)

    message = "Pricing updated for #{learner_info.full_name}."
    learner_info.notify_recipients(learner_info.finance_users, message)

    Rails.logger.info("[LearnerFinance##{id}] Sent pricing change notification for LearnerInfo ID #{learner_info.id}")
  end

  def notify_finance_created
    return unless learner_info.present?

    message = "Finance record created for #{learner_info.full_name}."
    learner_info.notify_recipients(learner_info.finance_users, message)

    Rails.logger.info("[LearnerFinance##{id}] Sent finance created notification for LearnerInfo ID #{learner_info.id}")
  end
end
