class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :goals
  belongs_to :subject, optional: true
end
