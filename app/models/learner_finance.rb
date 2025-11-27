class LearnerFinance < ApplicationRecord
  include LearnerNotifications

  belongs_to :learner_info

  validates :admission_fee, :monthly_fee, :renewal_fee,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :discount_mf, :scholarship, :discount_af, :discount_rf,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }

  after_commit :notify_finance_update, on: :update
  after_create :notify_finance_created

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

  def notify_finance_update
    ignored_keys = %w[updated_at created_at]

    real_changes = saved_changes.keys - ignored_keys

    if real_changes.any?
      changed_list = real_changes.map { |k| k.humanize }.join(', ')

      message = "Finance updated for #{learner_info.full_name}. Fields changed: #{changed_list}."

      notify_recipients(self.class.finance_users, message)
    end
  end

  def notify_finance_created
    notify_recipients(self.class.finance_users, "Finance record created for #{learner_info.full_name}.")
  end
end
