require 'utilities/timeframe'
class MoodleTimeline < ApplicationRecord
  include ProgressCalculations
  include WorkingDaysAndHolidays
  include GenerateTopicDeadlines
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
  has_many :knowledges, dependent: :destroy

  validate :start_date_before_end_date
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_cannot_be_holidays
  validate :end_date_before_expected
  validates :user_id, uniqueness: { scope: :subject_id, message: "can only have one timeline per subject" }
  belongs_to :exam_date, optional: true

  after_create :check_if_math_al_timeline
  after_update :check_if_math_al_timeline
  after_save :update_parent_math_al_timeline, if: :math_al_block_timeline?
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

    # Determine which blocks are selected (in order)
    selected_subject_ids = []
    selected_subject_ids << 1001 if self.blocks.first
    selected_subject_ids << 1002 if self.blocks.second
    selected_subject_ids << 1003 if self.blocks.third
    selected_subject_ids << 1004 if self.blocks.fourth

    # Destroy timelines for deselected blocks
    [1001, 1002, 1003, 1004].each do |sid|
      next if selected_subject_ids.include?(sid)
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: sid)
      mt.destroy if mt.present?
    end

    # Ensure timelines exist for selected blocks, collect them preserving order
    children = []
    selected_subject_ids.each do |sid|
      mt = MoodleTimeline.find_by(user_id: user_id, subject_id: sid)
      if mt.nil?
        mt = MoodleTimeline.create!(
          user_id: user_id,
          subject_id: sid,
          start_date: self.start_date,
          end_date: self.end_date,
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
      children << mt
    end

    # Proportionally split the parent's date range based on ECT/time values of each block's topics
    if children.any? && self.start_date.present? && self.end_date.present?
      total_days_inclusive = (self.end_date - self.start_date).to_i + 1

      # Calculate total ECT time for each child block and the sum of all blocks
      block_ect_times = children.map do |child|
        child.moodle_topics.sum(:time).to_f
      end

      total_ect_time = block_ect_times.sum

      # If no ECT data available, fall back to even distribution
      if total_ect_time == 0
        num_segments = children.size
        base_length = total_days_inclusive / num_segments
        remainder = total_days_inclusive % num_segments

        segment_start = self.start_date
        children.each_with_index do |mt, index|
          segment_length = base_length + (index < remainder ? 1 : 0)
          segment_end = segment_start + (segment_length - 1)
          mt.update!(start_date: segment_start, end_date: segment_end)
          segment_start = segment_end + 1
        end
      else
        # Distribute days proportionally based on ECT time
        segment_start = self.start_date

        children.each_with_index do |mt, index|
          # Calculate percentage of total time for this block
          block_percentage = block_ect_times[index] / total_ect_time

          # Calculate days for this block (round to ensure we use all days)
          if index == children.size - 1
            # Last block gets remaining days to ensure exact total
            segment_end = self.end_date
          else
            segment_days = (total_days_inclusive * block_percentage).round
            segment_days = [segment_days, 1].max  # Ensure at least 1 day
            segment_end = segment_start + (segment_days - 1)
          end

          mt.update!(start_date: segment_start, end_date: segment_end)
          segment_start = segment_end + 1
        end
      end
    end

    # Ensure topics are up to date for children (requires children to exist)
    begin
      self.update_blocks_topics
    rescue => e
      Rails.logger.warn "update_blocks_topics failed during AL blocks setup: #{e.message}"
    end

    # Regenerate deadlines for each child timeline
    children.each do |mt|
      begin
        moodle_generate_topic_deadlines(mt)
      rescue => e
        Rails.logger.warn "Failed to generate deadlines for child moodle_timeline #{mt.id}: #{e.message}"
      end
    end

    self.moodle_topics.first&.destroy if self.moodle_topics.many?
  end

  def create_moodle_topics
    if self.subject_id == 80
      create_maths_al_topic
    else
      user_id = self.user.moodle_id
      course_id = self.moodle_id

      if self.subject.board == "Portuguese Curriculum" || self.subject.board == "UP"
        user_id = 2617
      end

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

        next if [0, 1, 2].include?(self.subject.category)
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
          time: activity[:ect] || 0.001,  # Default to 1 if ect is nil or 0
          name: activity[:name],
          unit: activity[:section_name],  # Store section name as unit
          order: index + 1,  # Use index to maintain order
          grade: activity[:grade].present? ? activity[:grade].round(2) : nil,  # Grade is already a number from the API
          done: (activity[:completiondata].to_i == 1 || activity[:completiondata].to_i == 2),  # Mark as done if completed
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
          as1: as1,
          as2: as2
        )
      end

      moodle_generate_topic_deadlines(self)
    end
  end

  def update_moodle_topics
    if self.subject_id == 80
      update_maths_al_topics
    elsif self.subject_id == 1001 || self.subject_id == 1002 || self.subject_id == 1003 || self.subject_id == 1004
      update_blocks_topics
    else
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

        # Check for mock result changes before updating
        mock50_changed = moodle_topic.mock50 != (activity[:mock50].to_i == 1)
        mock100_changed = moodle_topic.mock100 != (activity[:mock100].to_i == 1)

        # Only update the done flag to avoid touching other fields
        update_attrs = {
          submission_date: Time.at(activity[:submission_date].to_i).strftime("%d/%m/%Y %H:%M"),
          number_attempts: activity[:number_attempts],
          grade: activity[:grade].present? ? activity[:grade].round(2) : nil,
          done: (activity[:completiondata].to_i == 1 || activity[:completiondata].to_i == 2),
          time: activity[:ect],
          mock50: activity[:mock50].to_i == 1,
          mock100: activity[:mock100].to_i == 1
        }

        topics_to_update << {
          topic: moodle_topic,
          attrs: update_attrs,
          mock50_changed: mock50_changed,
          mock100_changed: mock100_changed
        }
      end

      # Perform bulk updates with error handling
      topics_to_update.each do |update_data|
        begin
          update_data[:topic].update!(update_data[:attrs])

          # Create notifications for mock result changes
          if update_data[:mock50_changed] && update_data[:topic].mock50
            create_mock_notification(update_data[:topic], "Mock 50% result received")
          end

          if update_data[:mock100_changed] && update_data[:topic].mock100
            create_mock_notification(update_data[:topic], "Mock 100% result received")
          end

        rescue => e
          Rails.logger.error "Failed to update moodle_topic #{update_data[:topic].id}: #{e.message}"
        end
      end
    end
  end

  def create_maths_al_topic
    MoodleTopic.find_or_create_by!(
      moodle_timeline_id: self.id,
      name: "Edit this timeline and select which blocks you want to track",
      unit: "Setup your timeline",
      order: 1,
      time: 0.1,
      done: false
    )
  end

  def update_maths_al_topics
    # Handle subject_id == 80 case (unchanged)

    done_block_1 = false
    done_block_2 = false
    done_block_3 = false
    done_block_4 = false
    mt_1001 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1001)
    mt_1002 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1002)
    mt_1003 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1003)
    mt_1004 = MoodleTimeline.find_by(user_id: user_id, subject_id: 1004)
    done_block_1 = mt_1001.progress == 100 if mt_1001.present?
    done_block_2 = mt_1002.progress == 100 if mt_1002.present?
    done_block_3 = mt_1003.progress == 100 if mt_1003.present?
    done_block_4 = mt_1004.progress == 100 if mt_1004.present?

    topics = []
    if self.blocks.first
      topics << { name: "Pure Maths AS", unit: "Pure Maths AS", order: 1, done: done_block_1, deadline: mt_1001&.end_date }
    end
    if self.blocks.second
      topics << { name: "Statistics", unit: "Statistics", order: 2, done: done_block_2, deadline: mt_1002&.end_date }
    end
    if self.blocks.third
      topics << { name: "Pure Maths AL", unit: "Pure Maths AL", order: 3, done: done_block_3, deadline: mt_1003&.end_date }
    end
    if self.blocks.fourth
      topics << { name: "Mechanics", unit: "Mechanics", order: 4, done: done_block_4, deadline: mt_1004&.end_date }
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
          deadline: topic[:deadline],  # Set to child's end date
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
      else
        # Update deadline to reflect current child timeline end date
        if mt.deadline != topic[:deadline]
          mt.update(deadline: topic[:deadline])
        end
      end
    end
    self.update_blocks_topics
  end

  def update_blocks_topics
    app_user_id = self.user_id
    moodle_user_id = self.user.moodle_id
    course_id = self.moodle_id

    completed_activities = MoodleApiService.new.get_all_course_activities(course_id, moodle_user_id)
    pure_maths_as = MoodleTimeline.find_by(user_id: app_user_id, subject_id: 1001)
    statistics = MoodleTimeline.find_by(user_id: app_user_id, subject_id: 1002)
    pure_maths_al = MoodleTimeline.find_by(user_id: app_user_id, subject_id: 1003)
    mechanics = MoodleTimeline.find_by(user_id: app_user_id, subject_id: 1004)

    # sections_names
    sections_pure_maths_as = ["Pure Mathematics (AS)", "Unit 2: Algebra and Functions (AS) - Part I", "Unit 2: Algebra and Functions (AS) - Part II", "Unit 2: Algebra and Functions (AS) - Part III", "Unit 2: Algebra and Functions (AS) - Part IV", "Cross Unit Assessment 1 (AS)", "Unit 3: Coordinate Geometry (AS)", "Unit 4: Sequences, Series and Binomial Expansion (AS) - Part I", "Unit 4: Sequences, Series and Binomial Expansion (AS) - Part II", "Cross Unit Assessment 2 (AS)", "Unit 5: Trigonometry (AS) - Part I", "Unit 5: Trigonometry (AS) - Part II", "Unit 6: Logarithms and Exponentials (AS)", "Cross Unit Assessment 3 (AS)", "Unit 7: Differentiation (AS)", "Unit 8: Integration (AS)", "Cross Unit Assessment 4 (AS)", "Pure Maths Mock Exam (AS)"]
    sections_statistics = ["Probability and Statistics (AS)", "Unit 11: Representing and Summarising Data (AS)", "Unit 12: Probability (AS)", "Unit 13: Correlation and Regression (AS)", "Cross Unit Assessment 5 (AS)", "Unit 14: Discrete Random Variables (AS)", "Unit 15: Continuous Random Variables (AS)", "Cross Unit Assessment 6 (AS)", "Statistics 1 - Mock Exam (AS)", "P1 + P2 + S1 Exam Revision"]
    sections_pure_maths_al = ["Pure Mathematics (AL)", "Unit 1: Proof (AL)", "Unit 2: Algebra and Functions (AL)", "Cross Unit Assessment 1 (AL)", "Unit 3: Coordinate Geometry (AL)", "Unit 4: Sequences, Series and Binomial Expansion (AL)", "Cross Unit Assessment 2 (AL)", "Unit 5: Trigonometry (AL)", "Unit 6: Exponential & Logarithmic Functions (AL)", "Cross Unit Assessment 3 (AL)", "Unit 7: Differentiation (AL)", "Unit 8: Integration (AL)", "Cross Unit Assessment 4 (AL)", "Unit 9: Numerical Methods (AL)", "Unit 10: Vectors (AL)", "Cross Unit Assessment 5 (AL)", "Paper 3 MOCK Exam (AL)", "Paper 4 MOCK Exam (AL)"]
    sections_mechanics = ["Mechanics (AL)", "Unit 15: Topic 15.1. Quantities and Units in Mechanics", "Unit 16: Kinematics", "Unit 17: Forces and Newton’s Laws", "Unit 18: Topic 18.1. Moments", "Mechanics 1 - Mock Exam (AL)"]

    # Per-block ordering counters
    order_counters = { pure_as: 0, stats: 0, pure_al: 0, mech: 0 }

    completed_activities.each do |activity|
      section = activity[:section_name]
      time_val = activity[:ect].to_f > 0 ? activity[:ect].to_f : 0.001
      submission_str = activity[:submission_date].to_s
      submission_date = submission_str.empty? ? nil : Time.at(submission_str.to_i).strftime("%d/%m/%Y %H:%M")

      if sections_pure_maths_as.include?(section) && pure_maths_as
        order_counters[:pure_as] += 1
        topic = pure_maths_as.moodle_topics.find_or_initialize_by(name: activity[:name], unit: section)
        topic.assign_attributes(order: order_counters[:pure_as], time: time_val, done: activity[:completiondata].to_i == 1, moodle_id: activity[:id], submission_date: submission_date, number_attempts: activity[:number_attempts], grade: activity[:grade].present? ? activity[:grade].round(2) : nil)
        topic.save!
      elsif sections_statistics.include?(section) && statistics
        order_counters[:stats] += 1
        topic = statistics.moodle_topics.find_or_initialize_by(name: activity[:name], unit: section)
        topic.assign_attributes(order: order_counters[:stats], time: time_val, done: activity[:completiondata].to_i == 1, moodle_id: activity[:id], submission_date: submission_date, number_attempts: activity[:number_attempts], grade: activity[:grade].present? ? activity[:grade].round(2) : nil)
        topic.save!
      elsif sections_pure_maths_al.include?(section) && pure_maths_al
        order_counters[:pure_al] += 1
        topic = pure_maths_al.moodle_topics.find_or_initialize_by(name: activity[:name], unit: section)
        topic.assign_attributes(order: order_counters[:pure_al], time: time_val, done: activity[:completiondata].to_i == 1, moodle_id: activity[:id], submission_date: submission_date, number_attempts: activity[:number_attempts], grade: activity[:grade].present? ? activity[:grade].round(2) : nil)
        topic.save!
      elsif sections_mechanics.include?(section) && mechanics
        order_counters[:mech] += 1
        topic = mechanics.moodle_topics.find_or_initialize_by(name: activity[:name], unit: section)
        topic.assign_attributes(order: order_counters[:mech], time: time_val, done: activity[:completiondata].to_i == 1, moodle_id: activity[:id], submission_date: submission_date, number_attempts: activity[:number_attempts], grade: activity[:grade].present? ? activity[:grade].round(2) : nil)
        topic.save!
      end
    end
  end

  # Backwards-compatible alias used in older code paths
  def create_blocks_topics
    update_blocks_topics
  end

  def update_as1_as2
    if self.as1 == true && self.as2 == false
      self.moodle_topics.where(as1: false).destroy_all
    elsif self.as2 == true && self.as1 == false
      self.moodle_topics.where(as2: false).destroy_all
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

  # Check if this is a Math A Level block timeline (subject_id: 1001, 1002, 1003, 1004)
  def math_al_block_timeline?
    [1001, 1002, 1003, 1004].include?(subject_id)
  end

  # Update the parent Math A Level timeline (subject_id: 80) by aggregating block progress
  def update_parent_math_al_timeline
    return unless math_al_block_timeline?

    # Find the parent Math A Level timeline for this user
    parent_timeline = MoodleTimeline.find_by(user_id: user_id, subject_id: 80)
    return unless parent_timeline

    # Get all active Math A Level block timelines for this user
    block_timelines = MoodleTimeline.where(
      user_id: user_id,
      subject_id: [1001, 1002, 1003, 1004]
    )

    return if block_timelines.empty?

    # Calculate aggregated progress and expected progress
    total_progress = block_timelines.sum(:progress)
    total_expected_progress = block_timelines.sum(:expected_progress)
    num_blocks = block_timelines.count

    # Calculate averages
    avg_progress = num_blocks > 0 ? (total_progress.to_f / num_blocks).round : 0
    avg_expected_progress = num_blocks > 0 ? (total_expected_progress.to_f / num_blocks).round : 0

    # Calculate balance (average of block balances)
    total_balance = block_timelines.sum(:balance)
    avg_balance = num_blocks > 0 ? (total_balance.to_f / num_blocks).round : 0

    # Update parent timeline (skip callbacks to avoid infinite recursion)
    parent_timeline.update_columns(
      progress: avg_progress,
      expected_progress: avg_expected_progress,
      balance: avg_balance,
      difference: avg_progress - avg_expected_progress
    )

    Rails.logger.info "Updated Math A Level timeline #{parent_timeline.id}: progress=#{avg_progress}%, expected=#{avg_expected_progress}%, balance=#{avg_balance}"
  end

  # Class method to manually update all Math A Level parent timelines
  def self.update_all_math_al_parent_timelines
    # Find all Math A Level parent timelines (subject_id: 80)
    parent_timelines = MoodleTimeline.where(subject_id: 80)

    parent_timelines.each do |parent_timeline|
      # Find any block timeline for this user to trigger the update
      block_timeline = MoodleTimeline.find_by(
        user_id: parent_timeline.user_id,
        subject_id: [1001, 1002, 1003, 1004]
      )

      # Trigger the update if a block exists
      block_timeline&.send(:update_parent_math_al_timeline)
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

    timeline_name = subject&.name.presence || personalized_name.presence || "Moodle Timeline"
    actor_name = actor&.full_name || 'System'
    message = "Moodle Timeline '#{timeline_name}' for #{learner.full_name} was updated by #{actor_name}: #{parts.join(', ')}"

    # build a link to the learner timeline
    link = Rails.application.routes.url_helpers.learner_profile_path(learner.id, active_tab: 'moodle-timelines', selected_timeline_id: id)

    # create notifications
    recipients.each do |rcpt|
      n = Notification.find_or_initialize_by(user: rcpt, link: link, message: message)
      n.read = false
      n.save!
    end
  rescue => e
    Rails.logger.error "Moodle_timeline#notify_users error: #{e.class} #{e.message}\n#{e.backtrace.first(8).join("\n")}"
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

  def create_mock_notification(topic, message)
    return unless user.present?

    # Find LCs associated with this user's hub (only those with less than 3 hubs)
    lcs = user.users_hubs.find_by(main: true)&.hub.users.where(role: 'lc', deactivate: false).select { |lc| lc.hubs.count < 4 }

    return unless lcs.present?

    lcs.each do |lc|
      Notification.create!(
        user: lc,
        message: "#{message} - #{topic.subject.name} - #{user.full_name}"
      )
    end
  rescue => e
    Rails.logger.error "Failed to create mock notification: #{e.message}"
  end
end
