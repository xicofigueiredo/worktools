class Skill < ApplicationRecord
  belongs_to :sprint_goal
  has_one :report_activity, dependent: :destroy
end
