class Interrogation < ApplicationRecord
  has_many :form_interrogation_joins
  has_many :forms, through: :form_interrogation_joins

  scope :active, -> { where(active: true) }
end
