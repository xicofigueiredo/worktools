class WeeklyGoal < ApplicationRecord
  belongs_to :user

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :user_id, presence: true
  has_many :weekly_slots, dependent: :destroy
end
