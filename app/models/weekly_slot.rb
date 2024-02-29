class WeeklySlot < ApplicationRecord
  belongs_to :weekly_goal

  enum day_of_week: [:monday, :tuesday, :wednesday, :thursday, :friday]
  enum time_slot: [:early_morning, :morning, :late_morning, :early_afternoon, :afternoon, :late_afternoon]
end
