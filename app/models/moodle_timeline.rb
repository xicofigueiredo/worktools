class MoodleTimeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true
  after_create :create_moodle_topics
  after_update :update_moodle_topics
  after_update :update_as1_as2
  after_save :clear_monthly_goals_cache, if: :dates_changed?
  before_save :calculate_difference, if: :progress_and_expected_progress_present?

  # has_many :knowledges, dependent: :destroy
  before_destroy :destroy_associated_moodle_topics
  # belongs_to :exam_date, optional: true
  # has_many :timeline_progresses, dependent: :destroy
  # has_many :weeks, through: :timeline_progresses
  has_many :moodle_topics, dependent: :destroy

  validate :start_date_before_end_date
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_cannot_be_holidays
  validate :end_date_before_expected
  belongs_to :exam_date, optional: true


  def create_moodle_topics

    user_id = self.user.moodle_id
    course_id = self.moodle_id
    completed_activities = MoodleApiService.new.get_course_activities(course_id, user_id)
    ref_index = -1
    as1 = nil
    as2 = nil

    completed_activities.each_with_index do |activity, index|

      next if activity[:section_visible] == 0
      if self.category == 4
        if index > ref_index
          as1 = true
          as2 = false
        else
          as1 = false
          as2 = true
        end

        if activity[:mock50] == 1
          ref_index = index + 1
        else
          ref_index += 1
        end
      end

      MoodleTopic.create!(
        moodle_timeline_id: self.id,
        time: activity[:ect].to_i || 1,  # Default to 1 if ect is nil or 0
        name: activity[:name],
        unit: activity[:section_name],  # Store section name as unit
        order: index + 1,  # Use index to maintain order
        grade: activity[:grade],  # Grade is already a number from the API
        done: activity[:completiondata] == 1,  # Mark as done if completed
        completion_date: begin
          if activity[:evaluation_date].present?
            DateTime.parse(activity[:evaluation_date])
          else
            nil
          end
        rescue Date::Error => e
          puts "Warning: Invalid date format for activity #{activity[:name]}: #{activity[:evaluation_date]}"
          nil
        end,
        moodle_id: activity[:id],
        deadline: Date.today + 1.year,  # Set a default deadline
        percentage: index * 0.001,
        mock50: activity[:mock50] == 1,
        mock100: activity[:mock100] == 1,
        number_attempts: activity[:number_attempts],
        submission_date: Time.at(activity[:submission_date].to_i).strftime("%d/%m/%Y %H:%M"),
        evaluation_date: Time.at(activity[:evaluation_date].to_i).strftime("%d/%m/%Y %H:%M"),
        completion_data: Time.at(activity[:completiondata].to_i).strftime("%d/%m/%Y %H:%M"),
        as1: as1,
        as2: as2
      )
    end
  end

  def update_as1_as2
    if self.as1 == true && self.as2 == false
      self.moodle_topics.where(as1: false).destroy_all
    elsif self.as2 == true && self.as1 == false
      self.moodle_topics.where(as2: false).destroy_all
    end
  end

  def update_moodle_topics
    user_id = self.user.moodle_id
    course_id = self.moodle_id
    completed_activities = MoodleApiService.new.get_course_activities(course_id, user_id)

    completed_activities.each do |activity|
      next if activity[:section_visible] == 0

      moodle_topic = self.moodle_topics.find_by(moodle_id: activity[:id])
      next unless moodle_topic

      moodle_topic.update!(
        grade: activity[:grade],
        done: activity[:completiondata] == 1,
        completion_date: begin
          if activity[:evaluation_date].present?
            DateTime.parse(activity[:evaluation_date])
          else
            nil
          end
        rescue Date::Error => e
          puts "Warning: Invalid date format for activity #{activity[:name]}: #{activity[:evaluation_date]}"
          nil
        end,
        number_attempts: activity[:number_attempts],
        submission_date: Time.at(activity[:submission_date].to_i).strftime("%d/%m/%Y %H:%M"),
        evaluation_date: Time.at(activity[:evaluation_date].to_i).strftime("%d/%m/%Y %H:%M"),
        completion_data: Time.at(activity[:completiondata].to_i).strftime("%d/%m/%Y %H:%M")
      )
    end
  end

  def start_date_before_end_date
    return unless start_date && end_date && start_date >= end_date

    errors.add(:end_date, "must be after the start date")
  end

  def destroy_associated_moodle_topics
    self.moodle_topics.destroy_all
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
    return unless exam_date_id

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

  private

  def progress_and_expected_progress_present?
    progress.present? && expected_progress.present?
  end
end
