class Question < ApplicationRecord
  has_many :kdas_questions
  has_many :questions_sprint_goals
  has_many :sprint_goals, through: :questions_sprint_goals
  has_many :kdas, through: :kdas_questions
  has_many :answers
end
