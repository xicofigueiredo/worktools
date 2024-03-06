class WeeklyGoal < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, presence: true
  has_many :weekly_slots, dependent: :destroy
  accepts_nested_attributes_for :weekly_slots
end
