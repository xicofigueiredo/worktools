class ExamEnroll < ApplicationRecord
  belongs_to :moodle_timeline, optional: true
  belongs_to :timeline, optional: true
  has_many :exam_enroll_documents, dependent: :destroy
  # Paper cost validations
  validates :paper1_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :paper2_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :paper3_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :paper4_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :paper5_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Ensure paper cost is present if paper is present
  validates :paper1_cost, presence: true, if: -> { paper1.present? }
  validates :paper2_cost, presence: true, if: -> { paper2.present? }
  validates :paper3_cost, presence: true, if: -> { paper3.present? }
  validates :paper4_cost, presence: true, if: -> { paper4.present? }
  validates :paper5_cost, presence: true, if: -> { paper5.present? }

  # Validations for DC approval
  # validates :dc_approval_justification, presence: true, if: :dc_approval_present?
  # validates :dc_approval_comment, presence: true, if: :dc_approval_present?

  attr_accessor :changed_by_user_email

  after_create :log_initial_finance_status, if: -> { self.class.column_names.include?('finance_status') }
  before_save :set_status
  before_save :update_exam_finance_status
  before_save :log_finance_status_change, if: -> { self.class.column_names.include?('finance_status') && respond_to?(:finance_status_changed?) && finance_status_changed? }

  def update_exam_finance_status
    if self.display_exam_date.present?
      exam_date = self.display_exam_date
    else
      exam_date = ""
    end
    exam_finance = ExamFinance.find_by(user_id: self.timeline.user_id, exam_season: exam_date)
    if exam_finance.present?
      exam_enrolls = ExamEnroll.joins(:timeline)
          .includes(:timeline)
          .where(timelines: { user_id: exam_finance.user_id, hidden: false })
          .select { |enroll| enroll.display_exam_date == exam_finance.exam_season }
          .count

      exam_finance.update(exam_season: exam_date, number_of_subjects: exam_enrolls)
    else
      ExamFinance.create!(
        user_id: self.timeline.user_id,
        status: "No Status",
        exam_season: exam_date,
        total_cost: 0,           # Required field
        number_of_subjects: 1      # Required field
      )
    end
  end

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
    if self.pre_registration_exception_justification != "" && self.pre_registration_exception_justification != nil && self.pre_registration_exception_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_justification != nil && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == nil
      self.status = "Edu Approval Pending"
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_justification != nil && self.pre_registration_exception_dc_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_justification != nil && self.pre_registration_exception_edu_approval == false
      self.status = "Rejected"
      #notify lc and learner to reset exam season
      users_ids.each do |user_id|
        Notification.create(
          user_id: user_id,
          message: "A pre-registration exception has been rejected. A new exam season for #{self.subject_name}(#{self.learner_name}) is needed. Please update it! "
        )
      end
    elsif self.pre_registration_exception_justification != "" && self.pre_registration_exception_justification != nil && self.pre_registration_exception_dc_approval == true && self.pre_registration_exception_edu_approval == true
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
    if self.extension_justification != "" && self.extension_justification != nil && self.extension_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.extension_justification != "" && self.extension_justification != nil && self.extension_dc_approval == true && self.extension_edu_approval == nil
      self.status = "Edu Approval Pending"
    elsif self.extension_justification != "" && self.extension_justification != nil && self.extension_dc_approval == false
      self.status = "Rejected"
    elsif self.extension_justification != "" && self.extension_justification != nil && self.extension_edu_approval == false
      self.status = "Rejected"
    elsif self.extension_justification != "" && self.extension_justification != nil && self.extension_dc_approval == true && self.extension_edu_approval == true
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
    if self.failed_mock_exception_justification != "" && self.failed_mock_exception_justification != nil && self.failed_mock_exception_dc_approval == nil
      self.status = "RM Approval Pending"
    elsif self.failed_mock_exception_justification != "" && self.failed_mock_exception_justification != nil && self.failed_mock_exception_dc_approval == true && self.failed_mock_exception_edu_approval == nil
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

  def log_finance_status_change
    return unless timeline.present?
    return unless self.class.column_names.include?('finance_status')

    old_status = finance_status_was || 'No Status'
    new_status = finance_status || 'No Status'

    return if old_status == new_status

    exam_date = display_exam_date.presence || ""
    exam_finance = ExamFinance.find_by(user_id: timeline.user_id, exam_season: exam_date)

    return unless exam_finance.present?

    changes = exam_finance.status_changes || []
    changes << {
      'from' => old_status,
      'to' => new_status,
      'changed_at' => Time.current.iso8601,
      'changed_by' => changed_by_user_email || 'System',
      'subject' => subject_name || 'Unknown Subject',
      'enrollment_id' => id
    }

    exam_finance.update_column(:status_changes, changes)
  end

  def log_initial_finance_status
    return unless timeline.present?
    return unless self.class.column_names.include?('finance_status')
    return unless finance_status.present?

    exam_date = display_exam_date.presence || ""
    exam_finance = ExamFinance.find_by(user_id: timeline.user_id, exam_season: exam_date)

    return unless exam_finance.present?

    changes = exam_finance.status_changes || []
    changes << {
      'from' => 'Created',
      'to' => finance_status || 'No Status',
      'changed_at' => created_at.iso8601,
      'changed_by' => changed_by_user_email || 'System',
      'subject' => subject_name || 'Unknown Subject',
      'enrollment_id' => id
    }

    exam_finance.update_column(:status_changes, changes)
  end
end
