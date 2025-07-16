class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true
  has_many :exam_enroll_documents, dependent: :destroy
  has_many :specific_papers, dependent: :destroy

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?

  before_save :set_status

  def display_exam_date
    if personalized_exam_date.present?
      begin
        # Handle both Date objects and String values
        date_obj = personalized_exam_date.is_a?(Date) ? personalized_exam_date : Date.parse(personalized_exam_date.to_s)
        date_obj.strftime("%B %Y")
      rescue ArgumentError
        personalized_exam_date.to_s
      end
    elsif timeline&.exam_date&.date.present?
      timeline.exam_date.date.strftime("%B %Y")
    else
      "No exam date set"
    end
  end


  def set_status
    users_ids = []
    users_ids = [self.timeline.user_id] if self.timeline.present?
    if self.learning_coach_ids.present?
      users_ids += self.learning_coach_ids
    else
      if self.hub != "" && self.hub != nil
        hub = Hub.where(name: self.hub).first
        users_ids += User.joins(:users_hubs).where(role: "lc", users_hubs: {hub: hub}).pluck(:id)
      end
    end

    if !self.progress_cut_off && (self.extension_justification == "" || self.extension_justification == nil ) && (self.failed_mock_exception_justification == "" || self.failed_mock_exception_justification == nil ) && (self.pre_registration_exception_justification == "" || self.pre_registration_exception_justification == nil )
      self.status = "No Status"
    elsif !self.progress_cut_off && self.failed_mock_exception_edu_approval != true
      self.status = "Rejected"
    elsif (self.mock_results == "U" || self.mock_results == "0") && self.failed_mock_exception_edu_approval != true
      self.status = "Failed Mock"
    elsif self.progress_cut_off && (self.mock_results == nil || self.mock_results == "")
      self.status = "Mock Pending"
    else
      self.status = "Registered"
    end

    # pre-registration
    if self.pre_registration_exception_justification != "" && self.pre_registration_exception_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == nil
      self.status = "Edu Approval Pending"
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_dc_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_edu_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == true
      if self.mock_results == "U" || self.mock_results == "0"
        self.status = "Failed Mock"
        #notify lc and learner to request a failed mock exception
        users_ids.each do |user_id|
          Notification.create(
            user_id: user_id,
            message: "A pre-registration exception has been rejected. Please request a failed mock exception for #{self.subject_name}(#{self.learner_name})"
          )
        end
      elsif self.mock_results == nil || self.mock_results == ""
        self.status = "Mock Pending"
      else
        self.status = "Registered"
      end
    end

    # extension
    if self.extension_justification != "" && self.extension_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.extension_justification != "" && self.extension_dc_approval == true && self.extension_edu_approval == nil
      self.status = "Edu Approval Pending"
    elsif self.extension_justification != "" && self.extension_dc_approval == false
      self.status = "Rejected"
    elsif self.extension_justification != "" && self.extension_edu_approval == false
      self.status = "Rejected"
    elsif self.extension_justification != "" && self.extension_dc_approval == true && self.extension_edu_approval == true
      if self.mock_results == "U" || self.mock_results == "0"
       self.status = "Failed Mock (Registered)"
       # notify lc and learner to request a failed mock exceptionvv
       users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "An extension has been rejected. Please request a new failed mock exception for #{self.subject_name}(#{self.learner_name})"
        )
      end
      elsif self.mock_results == nil || self.mock_results == ""
        self.status = "Mock Pending (Registered)"
      else
        self.status = "Registered"
      end
    end

    # failed mock
    if self.failed_mock_exception_justification != "" && self.failed_mock_exception_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.failed_mock_exception_justification != "" && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == nil
      self.status = "Edu Approval Pending"
    elsif self.failed_mock_exception_justification != "" && self.failed_mock_exception_dc_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A failed mock exception has been rejected. A new exam season for #{self.subject_name} Timeline (#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_edu_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A failed mock exception has been rejected. A new exam season for #{self.subject_name} Timeline (#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.failed_mock_exception_justification == "" && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == true
      self.status = "Registered"
    end

    if self.timeline && self.timeline.user.deactivate == true
      self.status = "Left BGA"
    end

  end
end
