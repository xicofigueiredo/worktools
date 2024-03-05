class WeeklyGoal < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  has_many :weekly_slots, dependent: :destroy
end
