class SprintGoal < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :questions

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true
end
