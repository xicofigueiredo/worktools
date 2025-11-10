class Submission < ApplicationRecord
  belongs_to :moodle_assignment, class_name: 'MoodleAssignment', foreign_key: :moodle_assignment_id

  validates :user_id, presence: true
  validates :moodle_submission_id, presence: true, uniqueness: true

  # after_commit :update_assignment_grading_time, on: [:create, :update, :destroy]

  private

  def update_assignment_grading_time
    return unless moodle_assignment_id.present?
    MoodleAssignment.find(moodle_assignment_id).recalculate_grading_time!
  end
end
