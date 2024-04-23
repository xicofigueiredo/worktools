class WeeklySlot < ApplicationRecord
  belongs_to :weekly_goal
  belongs_to :subject, optional: true
  belongs_to :topic, optional: true
  enum day_of_week: {
    monday_day: 0,
    tuesday_day: 1,
    wednesday_day: 2,
    thursday_day: 3,
    friday_day: 4
  }

  enum time_slot: {
    early_morning: 0,
    morning: 1,
    late_morning: 2,
    early_afternoon: 3,
    afternoon: 4,
    late_afternoon: 5
  }
end
