class Kda < ApplicationRecord
  belongs_to :user
  has_many :kdas_questions
  accepts_nested_attributes_for :kdas_questions, allow_destroy: true
end
