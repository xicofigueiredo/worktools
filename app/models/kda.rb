class Kda < ApplicationRecord
  belongs_to :user
  belongs_to :week
  has_one :sdl, dependent: :destroy
  has_one :ini, dependent: :destroy
  has_one :mot, dependent: :destroy
  has_one :p2p, dependent: :destroy
  has_one :hubp, dependent: :destroy

  accepts_nested_attributes_for :sdl, allow_destroy: true
  accepts_nested_attributes_for :ini, allow_destroy: true
  accepts_nested_attributes_for :mot, allow_destroy: true
  accepts_nested_attributes_for :p2p, allow_destroy: true
  accepts_nested_attributes_for :hubp, allow_destroy: true
end
