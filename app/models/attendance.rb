class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :weekly_goal, optional: true
end
