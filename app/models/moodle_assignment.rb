class MoodleAssignment < ApplicationRecord
  belongs_to :subject

  validates :moodle_id, presence: true, uniqueness: true
  validates :name, presence: true
end
