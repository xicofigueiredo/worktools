class Kda < ApplicationRecord
  belongs_to :user
  belongs_to :week
  has_many :kdas_questions, dependent: :destroy
  has_many :questions, through: :kdas_questions
  accepts_nested_attributes_for :kdas_questions, allow_destroy: true
end
