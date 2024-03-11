class SprintGoal < ApplicationRecord
  belongs_to :user
  belongs_to :sprint
  has_many :questions_sprint_goals
  has_many :questions, through: :questions_sprint_goals
  accepts_nested_attributes_for :questions_sprint_goals, allow_destroy: true
end
