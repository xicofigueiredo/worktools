class WeeklyMeeting < ApplicationRecord
  belongs_to :week
  belongs_to :hub
  has_many :meeting_slots, dependent: :destroy
  accepts_nested_attributes_for :meeting_slots, allow_destroy: true, update_only: true

end
