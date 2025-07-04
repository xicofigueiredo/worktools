class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true
  has_many :exam_enroll_documents, dependent: :destroy

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?

  before_save :set_status


  def set_status
    users_ids = self.learning_coach_ids + [self.timeline.user_id]

    if !self.progress_cut_off && self.failed_mock_exception_edu_approval != true
      self.update_column(:status, "Rejected")
      return
    end

    # pre-registration
    if self.pre_registration_exception_justification == "" && self.pre_registration_exception_dc_approval == nil
      self.update_column(:status, "DC Approval Pending")
    elsif self.pre_registration_exception_justification == "" && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == nil
      self.update_column(:status, "EDU Approval Pending")
    elsif self.pre_registration_exception_justification == "" && self.pre_registration_exception_dc_approval == false
      self.update_column(:status, "Rejected")
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification == "" && self.pre_registration_exception_edu_approval == false
      self.update_column(:status, "Rejected")
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification == "" && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == true
      if self.result == "U" || self.result == "0"
        self.update_column(:status, "Failed Mock")
        #notify lc and learner to request a failed mock exception
        users_ids.each do |user_id|
          Notification.create(
            user_id: user_id,
            message: "A pre-registration exception has been rejected. Please request a failed mock exception for #{self.subject_name}(#{self.learner_name})"
          )
        end
      elsif self.result.nil?
        self.update_column(:status, "Mock Pending")
      else
        self.update_column(:status, "Registered")
      end
    end

    # extension
    if self.extension_justification == "" && self.extension_dc_approval == nil
      self.update_column(:status, "DC Approval Pending")
    elsif self.extension_justification == "" && self.extension_dc_approval == true && self.extension_edu_approval == nil
      self.update_column(:status, "EDU Approval Pending")
    elsif self.extension_justification == "" && self.extension_dc_approval == false
      self.update_column(:status, "Rejected")
    elsif self.extension_justification == "" && self.extension_edu_approval == false
      self.update_column(:status, "Rejected")
    elsif self.extension_justification == "" && self.extension_dc_approval == true && self.extension_edu_approval == true
      if self.result == "U" || self.result == "0"
       self.update_column(:status, "Failed Mock (Registered)")
       # notify lc and learner to request a failed mock exceptionvv
       users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "An extension has been rejected. Please request a new failed mock exception for #{self.subject_name}(#{self.learner_name})"
        )
      end
      elsif self.result.nil?
        self.update_column(:status, "Mock Pending (Registered)")
      else
        self.update_column(:status, "Registered")
      end
    end

    # failed mock
    if self.failed_mock_exception_justification == "" && self.failed_mock_exception_dc_approval == nil
      self.update_column(:status, "DC Approval Pending")
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == nil
      self.update_column(:status, "EDU Approval Pending")
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_dc_approval == false
      self.update_column(:status, "Rejected")
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A failed mock exception has been rejected. A new exam season for #{self.subject_name} Timeline (#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_edu_approval == false
      self.update_column(:status, "Rejected")
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A failed mock exception has been rejected. A new exam season for #{self.subject_name} Timeline (#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == true
      self.update_column(:status, "Registered")
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
