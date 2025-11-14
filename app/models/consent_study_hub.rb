class ConsentStudyHub < ApplicationRecord
  belongs_to :week
  belongs_to :hub

  validates :week_id, presence: true
  validates :hub_id, presence: true
end
