class MoodleTimeline < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true
  has_one :exam_enroll, dependent: :destroy

  after_create :create_moodle_topics
  after_update :update_moodle_topics
  after_update :update_as1_as2
  after_save :clear_monthly_goals_cache, if: :dates_changed?
  before_save :calculate_difference, if: :progress_and_expected_progress_present?

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

  after_create :check_if_math_al_timeline
  after_update :check_if_math_al_timeline
  # after_update :update_exam_enroll_status

  def update_exam_enroll_status
    exam_enroll = ExamEnroll.find_by(user_id: user_id, subject_id: subject_id)
    if exam_enroll.present?
    else
      hub = self.user.users_hubs.find_by(main: true).hub.name
      lcs = self.user.users_hubs.includes(:hub).find_by(main: true)&.hub.users.where(role: 'lc').reject do |lc|
        lc.hubs.count >= 3
      end
      lc_ids = lcs.present? ? lcs.map(&:id) : []
      native_language_english = self.user.native_language == 'English' ? true : false

      exam_enroll = ExamEnroll.create!(
        hub: hub,
        learning_coach_ids: lc_ids,
        date_of_birth: self.user.birthday,
        # gender: self.user.gender,
        native_language_english: native_language_english,
        subject_name: self.subject.name,
        # code: self.subject.code,
        # qualification: self.subject.qualification,
        # progress_cut_off: self.progress_cut_off,
        moodle_timeline_id: self.id
        )

        if self.progress > 80
          exam_enroll.update(status: 'Registered')
        end
    end
  end


  def check_if_math_al_timeline
    return if self.subject_id != 80
    if self.blocks.first
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1001)
      if mt.nil?
        MoodleTimeline.create!(
          user_id: user_id,
          subject_id: 1001,
          start_date: Date.today,
          end_date: Date.today + 1.year,
          balance: 0,
          expected_progress: 0,
          progress: 0,
          total_time: 0,
          difference: 0,
          category: category,
          moodle_id: course_id,
          hidden: false,
          as1: nil,
          as2: nil
        )
      end
    else
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1001)
      mt.destroy if mt.present?
    end
    if self.blocks.second
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1002)
      if mt.nil?
        MoodleTimeline.create!(
          user_id: user_id,
          subject_id: 1002,
          start_date: Date.today,
          end_date: Date.today + 1.year,
          balance: 0,
          expected_progress: 0,
          progress: 0,
          total_time: 0,
          difference: 0,
          category: category,
          moodle_id: course_id,
          hidden: false,
          as1: nil,
          as2: nil
        )
      end
    else
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1002)
      mt.destroy if mt.present?
    end
    if self.blocks.third
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1003)
      if mt.nil?
        MoodleTimeline.create!(
          user_id: user_id,
          subject_id: 1003,
          start_date: Date.today,
          end_date: Date.today + 1.year,
          balance: 0,
          expected_progress: 0,
          progress: 0,
          total_time: 0,
          difference: 0,
          category: category,
          moodle_id: course_id,
          hidden: false,
          as1: nil,
          as2: nil
        )
      end
    else
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1003)
      mt.destroy if mt.present?
    end
    if self.blocks.fourth
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1004)
      if mt.nil?
        MoodleTimeline.create!(
          user_id: user_id,
          subject_id: 1004,
          start_date: Date.today,
          end_date: Date.today + 1.year,
          balance: 0,
          expected_progress: 0,
          progress: 0,
          total_time: 0,
          difference: 0,
          category: category,
          moodle_id: course_id,
          hidden: false,
          as1: nil,
          as2: nil
        )
      end
    else
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: 1004)
      mt.destroy if mt.present?
    end
    if self.moodle_topics.count > 1
      self.moodle_topics.first.destroy
    end
  end

  def create_moodle_topics
    if self.subject_id != 80
      user_id = self.user.moodle_id
      course_id = self.moodle_id
      completed_activities = MoodleApiService.new.get_all_course_activities(course_id, user_id)

      # Enrich missing ids (cmid) by name using core_course_get_contents
      if completed_activities.any? { |a| a[:id].nil? }
        begin
          contents = MoodleApiService.new.call('core_course_get_contents', { courseid: course_id })
          modules  = Array(contents).flat_map { |s| s['modules'] || [] }
          name_to_cmid = {}
          modules.each { |m| n = m['name']; name_to_cmid[n] ||= m['id'] if n }
          completed_activities.each { |a| a[:id] ||= name_to_cmid[a[:name]] }
        rescue => e
          Rails.logger.warn "Could not enrich moodle ids during create: #{e.message}"
        end
      end
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
          time: activity[:ect] || 1,  # Default to 1 if ect is nil or 0
          name: activity[:name],
          unit: activity[:section_name],  # Store section name as unit
          order: index + 1,  # Use index to maintain order
          grade: activity[:grade].present? ? activity[:grade].round(2) : nil,  # Grade is already a number from the API
          done: activity[:completiondata] == 1,  # Mark as done if completed
          completion_date: begin
            if activity[:evaluation_date].present?
              DateTime.parse(activity[:evaluation_date])
            else
              nil
            end
          rescue Date::Error
            puts "Warning: Invalid date format for activity #{activity[:name]}: #{activity[:evaluation_date]}"
            nil
          end,
          moodle_id: activity[:id],
          deadline: Date.today + 1.year,  # Set a default deadline
          percentage: index * 0.001,
          mock50: activity[:mock50].to_i == 1,
          mock100: activity[:mock100].to_i == 1,
          number_attempts: activity[:number_attempts],
          submission_date: Time.at(activity[:submission_date].to_i).strftime("%d/%m/%Y %H:%M"),
          evaluation_date: Time.at(activity[:evaluation_date].to_i).strftime("%d/%m/%Y %H:%M"),
          completion_data: Time.at(activity[:completiondata].to_i).strftime("%d/%m/%Y %H:%M"),
          as1: as1,
          as2: as2
        )
      end
    else
      MoodleTopic.create!(
        moodle_timeline_id: self.id,
        name: "Edit this timeline and select which blocks you want to track",
        unit: "Setup your timeline",
        order: 1,
        time: 0.1,
        done: false
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
    if self.subject_id != 80
      user_id = self.user.moodle_id
      course_id = self.moodle_id

      # Get all activities in one API call (now optimized)
      completed_activities = MoodleApiService.new.get_all_course_activities(course_id, user_id)

      # Get all moodle_topics for this timeline in one query to avoid N+1
      existing_topics = self.moodle_topics.index_by(&:moodle_id)

      # Prepare bulk updates
      topics_to_update = []

      completed_activities.each do |activity|
        next if activity[:section_visible] == 0

        # Prefer id match, but fallback by name and backfill moodle_id like sync
        moodle_topic = existing_topics[activity[:id]]
        if moodle_topic.nil?
          moodle_topic = self.moodle_topics.find_by(name: activity[:name])
          if moodle_topic && activity[:id].present? && moodle_topic.moodle_id.nil?
            moodle_topic.update_column(:moodle_id, activity[:id])
            existing_topics[activity[:id]] = moodle_topic
          end
        end
        next unless moodle_topic

        # Only update the done flag to avoid touching other fields
        update_attrs = {
          done: activity[:completiondata].to_i == 1
        }

        topics_to_update << { topic: moodle_topic, attrs: update_attrs }
      end

      # Perform bulk updates with error handling
      topics_to_update.each do |update_data|
        begin
          update_data[:topic].update!(update_data[:attrs])
        rescue => e
          Rails.logger.error "Failed to update moodle_topic #{update_data[:topic].id}: #{e.message}"
        end
      end

    else
      # Handle subject_id == 80 case (unchanged)
      user_id = self.user.moodle_id
      course_id = self.moodle_id

      done_block_1 = false
      done_block_2 = false
      done_block_3 = false
      done_block_4 = false
      # done_block_1 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1001).progress == 100
      # done_block_2 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1002).progress == 100
      # done_block_3 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1003).progress == 100
      # done_block_4 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1004).progress == 100

      topics = []
      if self.blocks.first
        topics << { name: "Block 1", unit: "Block 1", order: 1, done: done_block_1 }
      end
      if self.blocks.second
        topics << { name: "Block 2",unit: "Block 2",order: 2,done: done_block_2 }
      end
      if self.blocks.third
        topics << { name: "Block 3",unit: "Block 3",order: 3,done: done_block_3 }
      end
      if self.blocks.fourth
        topics << { name: "Block 4",unit: "Block 4",order: 4,done: done_block_4 }
      end

      topics.each do |topic|

        mt = MoodleTopic.find_by(
          moodle_timeline_id: self.id,
          name: topic[:name],
          unit: topic[:unit],
          order: topic[:order],
          time: 1,
          done: topic[:done]
        )
        if mt.nil?
          MoodleTopic.create!(
            moodle_timeline_id: self.id,
            name: topic[:name],
            unit: topic[:unit],
            order: topic[:order],
            time: 1,
            done: topic[:done],  # Mark as done if completed
            deadline: Date.today + 1.year,  # Set a default deadline
            percentage: 25,
            mock50: false,
            mock100: false,
            number_attempts: nil,
            submission_date: nil,
            evaluation_date: nil,
            completion_data: nil,
            as1: nil,
            as2: nil
          )
        end
      end
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

  private

  def parse_evaluation_date(date_value)
    return nil unless date_value.present?

    begin
      DateTime.parse(date_value)
    rescue Date::Error
      Rails.logger.warn "Warning: Invalid date format: #{date_value}"
      nil
    end
  end

  def format_timestamp(timestamp)
    return nil unless timestamp.present? && timestamp.to_i > 0

    begin
      Time.at(timestamp.to_i).strftime("%d/%m/%Y %H:%M")
    rescue
      Rails.logger.warn "Warning: Invalid timestamp: #{timestamp}"
      nil
    end
  end
end
