class WeeklyMeeting < ApplicationRecord
  belongs_to :week
  belongs_to :hub
  has_many :monday_slots, dependent: :destroy
  has_many :tuesday_slots, dependent: :destroy
  has_many :wednesday_slots, dependent: :destroy
  has_many :thursday_slots, dependent: :destroy
  has_many :friday_slots, dependent: :destroy
  accepts_nested_attributes_for :monday_slots, allow_destroy: true
  accepts_nested_attributes_for :tuesday_slots, allow_destroy: true
  accepts_nested_attributes_for :wednesday_slots, allow_destroy: true
  accepts_nested_attributes_for :thursday_slots, allow_destroy: true
  accepts_nested_attributes_for :friday_slots, allow_destroy: true
end
