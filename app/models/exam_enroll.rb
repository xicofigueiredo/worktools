class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true
  has_many :exam_enroll_documents, dependent: :destroy

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?




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

  # Callbacks to handle status changes
  # after_save :update_status_based_on_approvals


  private

  def dc_approval_present?
    !dc_approval.nil?
  end

  def update_status_based_on_approvals
    # Check if DC approval fields changed
    if saved_change_to_pre_registration_exception_dc_approval? ||
       saved_change_to_failed_mock_exception_dc_approval? ||
       saved_change_to_extension_dc_approval?

      handle_dc_approval_change
    end

    # Check if EDU approval fields changed
    if saved_change_to_pre_registration_exception_edu_approval? ||
       saved_change_to_failed_mock_exception_edu_approval? ||
       saved_change_to_extension_edu_approval?

      handle_edu_approval_change
    end
  end

  def handle_dc_approval_change
    if pre_registration_exception_dc_approval == false ||
       failed_mock_exception_dc_approval == false ||
       extension_dc_approval == false
      # If DC rejected any exception
      update_column(:status, 'rejected')
    elsif pre_registration_exception_dc_approval == true ||
          failed_mock_exception_dc_approval == true ||
          extension_dc_approval == true
      # If DC approved, move to EDU approval pending
      update_column(:status, 'approval_pending')
    end
  end

  def handle_edu_approval_change
    if pre_registration_exception_edu_approval == false ||
       failed_mock_exception_edu_approval == false ||
       extension_edu_approval == false
      # If EDU rejected any exception
      update_column(:status, 'rejected')
    elsif pre_registration_exception_edu_approval == true ||
          failed_mock_exception_edu_approval == true ||
          extension_edu_approval == true
      # If EDU approved
      update_column(:status, 'mock_pending')
    end
  end
end
