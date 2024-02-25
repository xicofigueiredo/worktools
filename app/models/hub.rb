class Hub < ApplicationRecord
  validates :name, presence: true
  validates :country, presence: true

  has_many :users_hub
  has_many :user, through: :users_hub
end
