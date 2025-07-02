class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline
  has_many :exam_enroll_documents, dependent: :destroy

  # Validations for DC approval
  validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  validates :dc_approval_comment, presence: true, if: :dc_approval_present?

  private

  def dc_approval_present?
    !dc_approval.nil?
  end
end
