class QuestionsSprintGoal < ApplicationRecord
  belongs_to :sprint_goal
  belongs_to :subject, optional: true
  belongs_to :question

  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true
end
