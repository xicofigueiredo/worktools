class MondaySlot < ApplicationRecord
  belongs_to :weekly_meeting
  belongs_to :lc, class_name: 'User', optional: true
  belongs_to :learner, class_name: 'User', optional: true
end
