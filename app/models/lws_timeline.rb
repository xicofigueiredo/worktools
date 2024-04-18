class LwsTimeline < ApplicationRecord
  belongs_to :user
  has_many :timelines, dependent: :destroy
end
