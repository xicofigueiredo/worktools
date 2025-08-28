class Consent < ApplicationRecord
  belongs_to :user
  belongs_to :sprint, optional: true
  belongs_to :week, optional: true
  has_many :consent_activities, dependent: :destroy
end
