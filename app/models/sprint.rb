class Sprint < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, presence: true

  has_many :questions_sprint_goals
  has_many :sprint_goals
end
