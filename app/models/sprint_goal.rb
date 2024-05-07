class SprintGoal < ApplicationRecord
  belongs_to :user
  belongs_to :sprint

  has_many :knowledges, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :communities, class_name: 'Community', dependent: :destroy

  validates :user, presence: true
  validates :sprint, presence: true

  accepts_nested_attributes_for :knowledges, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :communities, allow_destroy: true
end
