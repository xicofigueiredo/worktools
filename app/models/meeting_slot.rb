class MeetingSlot < ApplicationRecord
  belongs_to :weekly_meeting
  belongs_to :lc, class_name: 'User', foreign_key: 'lc_id', optional: true
  belongs_to :learner, class_name: 'User', foreign_key: 'learner_id', optional: true

  validates :day_of_week, inclusion: { in: %w[ Monday Tuesday Wednesday Thursday Friday ] }
end
