class Knowledge < ApplicationRecord
  belongs_to :sprint_goal
  belongs_to :timeline, optional: true
end
