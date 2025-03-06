class FormInterrogationJoin < ApplicationRecord
  belongs_to :form
  belongs_to :interrogation
  has_many :responses, dependent: :destroy

  validates :form_id, uniqueness: { scope: :interrogation_id }
end
