class SprintGoal < ApplicationRecord
  belongs_to :user
  belongs_to :sprint
  has_many :questions_sprint_goals
  has_many :questions, through: :questions_sprint_goals
  has_many :answers, through: :questions
end
