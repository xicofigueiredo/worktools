class Hub < ApplicationRecord
  validates :name, presence: true
  validates :country, presence: true

  has_many :users_hub
  has_many :users, through: :users_hub
  has_many :weekly_meetings, dependent: :destroy
end
