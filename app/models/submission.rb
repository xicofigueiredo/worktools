class Submission < ApplicationRecord
  belongs_to :moodle_assignment, class_name: 'MoodleAssignment', foreign_key: :moodle_assignment_id

  validates :user_id, presence: true
  validates :moodle_submission_id, presence: true, uniqueness: true
end
