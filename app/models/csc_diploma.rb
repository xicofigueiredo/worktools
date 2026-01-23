class CscDiploma < ApplicationRecord
  belongs_to :user
  has_many :csc_activities, dependent: :destroy
end
