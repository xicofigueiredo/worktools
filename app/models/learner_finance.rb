class LearnerFinance < ApplicationRecord
  belongs_to :learner_info

  validates :admission_fee, :monthly_fee, :renewal_fee,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :discount_mf, :scholarship, :discount_af, :discount_rf,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }

  after_update :send_pricing_change_notification, if: :pricing_changed?

  before_save :calculate_billable_amounts

  private

  def calculate_billable_amounts
    # Billable MF = Monthly Fee * (1 - (Discount MF % + Scholarship %) / 100)
    if monthly_fee.present?
      discount_percent = ((discount_mf || 0) + (scholarship || 0)) / 100.0
      self.billable_mf = [monthly_fee * (1 - discount_percent), 0].max
    end

    # Billable AF = Admission Fee * (1 - Discount AF % / 100)
    if admission_fee.present?
      discount_percent = (discount_af || 0) / 100.0
      self.billable_af = [admission_fee * (1 - discount_percent), 0].max
    end

    # Billable RF = Renewal Fee * (1 - Discount RF % / 100)
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
    return unless learner_info.status.in?(%w[In progress conditional In progress In progress - ok Waitlist Waitlist - ok Validated Onboarded])

    message = "Pricing updated for #{learner_info.full_name}"
    learner_info.notify_recipients(learner_info.finance_users, message)
  end
end
