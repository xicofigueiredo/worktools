class LearnerFinance < ApplicationRecord
  belongs_to :learner_info

  validates :admission_fee, :monthly_fee, :renewal_fee,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # Calculate billable amounts before save
  before_save :calculate_billable_amounts

  private

  def calculate_billable_amounts
    # Billable MF = Monthly Fee - (Discount MF + Scholarship)
    if monthly_fee.present?
      discount = (discount_mf || 0) + (scholarship || 0)
      self.billable_mf = monthly_fee - discount
    end

    # Billable AF = Admission Fee - Discount AF
    if admission_fee.present?
      self.billable_af = admission_fee - (discount_af || 0)
    end

    # Billable RF = Renewal Fee - Discount RF
    if renewal_fee.present?
      self.billable_rf = renewal_fee - (discount_rf || 0)
    end
  end
end
