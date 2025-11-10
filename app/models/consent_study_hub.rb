class ConsentStudyHub < ApplicationRecord
  belongs_to :week
  belongs_to :hub, optional: true

  validates :week_id, presence: true
  # Remove the hub_id validation since we're storing hub names in day fields
end
