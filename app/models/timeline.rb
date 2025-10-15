class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true

  # after_create :create_user_topics
  after_save :clear_monthly_goals_cache, if: :dates_changed?
  before_save :calculate_difference, if: :progress_and_expected_progress_present?

  has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_user_topics
  belongs_to :exam_date, optional: true
  belongs_to :lws_timeline, optional: true
  has_many :user_topics
  has_many :topics, through: :user_topics
  has_many :timeline_progresses, dependent: :destroy
  has_many :weeks, through: :timeline_progresses
  has_many :moodle_topics, dependent: :destroy
  has_one :exam_enroll, dependent: :destroy

  validate :start_date_before_end_date
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_cannot_be_holidays
  validate :end_date_before_expected

  # def create_user_topics
  #   subject.topics.order(:order).find_each do |topic|
  #     user.user_topics.create!(topic:, done: false)
  #   end
  # end

  after_update :create_exam_enroll

  def create_exam_enroll
    exam_enroll = ExamEnroll.find_by(timeline_id: self.id)
    if exam_enroll.nil?
      if self.exam_date.present?
        hub = self.user.users_hubs.find_by(main: true).hub.name
        lcs = self.user.users_hubs.includes(:hub).find_by(main: true)&.hub.users.where(role: 'lc', deactivate: false).reject do |lc|
          lc.hubs.count >= 3
        end
        lc_ids = lcs.present? ? lcs.map(&:id) : []
        user = self.user
        exam_enroll = ExamEnroll.create!(
          timeline_id: self.id,
          learner_name: user.full_name,
          hub: hub,
          learning_coach_ids: lc_ids,
          date_of_birth: user.birthday,
          subject_name: self.subject.name,
          progress_cut_off: self.progress,
          learner_id_number: user.id_number,
          gender: user.gender,
          native_language_english: user.native_language_english,
          code: self.subject.code,
          exam_board: self.subject.board,
          status: "No Status",
          qualification: case self.subject.category
                       when 'igcse' then 'IGCSE'
                       when 'as' then 'AS'
                       when 'al' then 'A Level'
                       else nil
                       end
        )
      end
    end
  end

  def start_date_before_end_date
    return unless start_date && end_date && start_date >= end_date

    errors.add(:end_date, "must be after the start date")
  end

  def destroy_associated_user_topics
    user.user_topics.joins(:topic).where(topics: { subject_id: }).destroy_all
  end

  def update_weekly_progress(week)
    tp = timeline_progresses.find_or_initialize_by(week:)
    tp.progress = progress
    tp.expected = expected_progress
    tp.difference = difference
    tp.save!
  end

  def dates_cannot_be_holidays
    holidays = user.holidays
    return unless holidays.include?(start_date) && holidays.include?(end_date)

    errors.add(:base, "Start date and end date cannot be on a holiday")
  end

  def dates_changed?
    saved_change_to_start_date? || saved_change_to_end_date?
  end

  def clear_monthly_goals_cache
    Rails.cache.delete("monthly_goals_#{Date.today.beginning_of_month}")
  end

  def calculate_difference
    if progress.present? && expected_progress.present?
      self.difference = progress - expected_progress
    else
      self.difference = nil
    end
  end

  def end_date_before_expected
    return unless exam_date

    # Skip this validation if only toggling the hidden state
    return if changed_attributes.keys == ['hidden']


    # Map the expected end date based on the exam month
    expected_end_date = case exam_date.date.month
                        when 5, 6 # May/June exams
                          Date.new(exam_date.date.year, 2, 28)
                        when 10, 11 # October/November exams
                          Date.new(exam_date.date.year, 7, 28)
                        when 1 # January exams
                          Date.new(exam_date.date.year - 1, 10, 28) # Previous year for October
                        else
                          nil
                        end

    # Validate if end_date is before or on the expected end date
    if expected_end_date && end_date > expected_end_date
      errors.add(:end_date, "must be on or before #{expected_end_date.strftime('%d %B %Y')} for the selected exam session.")
    end
  end

  def notify_users(actor)
    # Only consider relevant changes
    changes = saved_changes.slice('start_date', 'end_date', 'exam_date_id')
    return if changes.blank?

    learner = self.user

    hub = learner.users_hubs.find_by(main: true)&.hub
    return unless hub

    hub_lcs = hub.users.where(role: 'lc').reject do |lc|
      lc.hubs.count >= 3 || lc.deactivate
    end

    return if hub_lcs.blank?

    # decide recipients depending on who made the update
    recipients =
      if actor.present? && actor.id == learner.id
        # learner updated -> notify all LCs
        hub_lcs
      elsif actor.present? && actor.role == 'lc'
        # LC updated -> notify other LCs (exclude actor)
        hub_lcs.reject { |lc| lc.id == actor.id }
      else
        # system / unknown actor -> notify all LCs
        hub_lcs
      end

    return if recipients.blank?

    # Build human friendly change parts
    parts = changes.map do |attr, (old_val, new_val)|
      case attr
      when 'exam_date_id'
        old_label = ExamDate.find_by(id: old_val)&.date&.strftime('%d %b %Y') rescue old_val
        new_label = ExamDate.find_by(id: new_val)&.date&.strftime('%d %b %Y') rescue new_val
        "Exam session: #{old_label} → #{new_label}"
      when 'start_date', 'end_date'
        old_fmt = old_val.respond_to?(:strftime) ? old_val.strftime('%d %b %Y') : old_val
        new_fmt = new_val.respond_to?(:strftime) ? new_val.strftime('%d %b %Y') : new_val
        "#{attr.humanize}: #{old_fmt} → #{new_fmt}"
      else
        "#{attr.humanize}: #{old_val} → #{new_val}"
      end
    end

    timeline_name = subject&.name.presence || personalized_name.presence || "Timeline"
    actor_name = actor&.full_name || 'System'
    message = "Timeline '#{timeline_name}' for #{learner.full_name} was updated by #{actor_name}: #{parts.join(', ')}"

    # build a link to the learner timeline
    link = Rails.application.routes.url_helpers.learner_profile_path(learner.id, active_tab: 'timelines', selected_timeline_id: id)

    # create notifications
    recipients.each do |rcpt|
      n = Notification.find_or_initialize_by(user: rcpt, link: link, message: message)
      n.read = false
      n.save!
    end
  rescue => e
    Rails.logger.error "Timeline#notify_users error: #{e.class} #{e.message}\n#{e.backtrace.first(8).join("\n")}"
  end

  private

  def progress_and_expected_progress_present?
    progress.present? && expected_progress.present?
  end
end
