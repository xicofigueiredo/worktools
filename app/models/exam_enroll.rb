class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true
  has_many :exam_enroll_documents, dependent: :destroy

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?


  def set_status
    # pre-registration
    if self.pre_registration_exception_comment.present? && self.pre_registration_exception_dc_approval == nil
      self.status = "DC Approval Pending"
    elsif self.pre_registration_exception_comment.present? && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == nil
      self.status = "EDU Approval Pending"
    elsif self.pre_registration_exception_comment.present? && self.pre_registration_exception_dc_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
    elsif self.pre_registration_exception_comment.present? && self.pre_registration_exception_edu_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
    elsif self.pre_registration_exception_comment.present? && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == true
      if self.result == "U" || self.result == "0"
        self.status = "Failed Mock"
        #notify lc and learner to request a failed mock exception
      elsif self.result.nil?
        self.status = "Mock Pending"
      else
        self.status = "Registered"
      end
    end

    # extension
    if self.extension_comment.present? && self.extension_dc_approval == nil
      self.status = "DC Approval Pending"
    elsif self.extension_comment.present? && self.extension_dc_approval == true && self.extension_edu_approval == nil
      self.status = "EDU Approval Pending"
    elsif self.extension_comment.present? && self.extension_dc_approval == false
      self.status = "Rejected"
    elsif self.extension_comment.present? && self.extension_edu_approval == false
      self.status = "Rejected"
    elsif self.extension_comment.present? && self.extension_dc_approval == true && self.extension_edu_approval == true
      if self.result == "U" || self.result == "0"
       self.status = "Failed Mock (Registered)"
       # notify lc and learner to request a failed mock exceptionvv
      elsif self.result.nil?
        self.status = "Mock Pending (Registered)"
      else
        self.status = "Registered"
      end
    end

    # failed mock
    if self.failed_mock_exception_comment.present? && self.failed_mock_exception_dc_approval == nil
      self.status = "DC Approval Pending"
    elsif self.failed_mock_exception_comment.present? && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == nil
      self.status = "EDU Approval Pending"
    elsif self.failed_mock_exception_comment.present? && self.failed_mock_exception_dc_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
    elsif self.failed_mock_exception_comment.present? && self.failed_mock_exception_edu_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
    elsif self.failed_mock_exception_comment.present? && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == true
      self.status = "Registered"
    end

  end

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
