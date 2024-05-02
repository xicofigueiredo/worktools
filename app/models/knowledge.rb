class Knowledge < ApplicationRecord
  belongs_to :sprint_goal
  belongs_to :timeline, optional: true
  validates :mock50, :mock100, :exam_season, presence: false
end
