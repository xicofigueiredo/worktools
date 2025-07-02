class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline
  has_many :exam_enroll_documents, dependent: :destroy

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?

  STATUSES = %w[
    Rejected
    Approval Pending
    Mock Pending
    Failed Mock
    Registered
  ].freeze

  validates :status, inclusion: { in: STATUSES }

  # Enum for status
  enum status: {
    rejected: 'Rejected',
    approval_pending: 'Approval Pending',
    mock_pending: 'Mock Pending',
    failed_mock: 'Failed Mock',
    registered: 'Registered'
  }

  # Optional: Add helper methods to check status
  def rejected?
    status == 'rejected'
  end

  def pending_approval?
    status == 'approval_pending'
  end

  def pending_mock?
    status == 'mock_pending'
  end

  def failed_mock?
    status == 'failed_mock'
  end

  def registered?
    status == 'registered'
  end

  private

  def dc_approval_present?
    !dc_approval.nil?
  end
end
