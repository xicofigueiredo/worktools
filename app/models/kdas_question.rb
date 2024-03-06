class KdasQuestion < ApplicationRecord
  belongs_to :kda
  belongs_to :question
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers
end
