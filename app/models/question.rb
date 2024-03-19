class Question < ApplicationRecord
  has_many :kdas_questions
  has_many :kdas, through: :kdas_questions
  has_many :answers
end
