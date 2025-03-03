class Note < ApplicationRecord
  belongs_to :user

  validate :validate_category_for_cm

  private

  def validate_category_for_cm
    if user.present? && user.role == "cm" && category != "knowledge"
      errors.add(:category, "must be 'knowledge' for course managers")
    end
  end
end
