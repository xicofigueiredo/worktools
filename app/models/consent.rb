class Consent < ApplicationRecord
  belongs_to :user
  belongs_to :sprint, optional: true
  belongs_to :week, optional: true
  # Remove: has_many :consent_activities, dependent: :destroy
  # Remove: accepts_nested_attributes_for :consent_activities, allow_destroy: true, reject_if: :all_blank
end
