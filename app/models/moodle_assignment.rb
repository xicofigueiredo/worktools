class MoodleAssignment < ApplicationRecord
  belongs_to :subject
  has_many :submissions, foreign_key: :moodle_assignment_id, dependent: :destroy

  validates :moodle_id, presence: true, uniqueness: true
  validates :name, presence: true
end
