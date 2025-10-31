class WeeklyGoal < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, presence: true
  validates :week_id, presence: true
  has_many :weekly_slots, dependent: :destroy
  has_many :attendances, dependent: :nullify
  accepts_nested_attributes_for :weekly_slots

  after_create :associate_existing_attendances

  def calculate_expected_hours
    total_hours = 0.0

    # Get all weekly slots with non-empty subject and topic names
    slots_with_moodle = weekly_slots
      .where.not(subject_name: [nil, "", "Other"])
      .where.not(topic_name: [nil, ""])
      .select(:subject_name, :topic_name)
      .distinct

    # Group slots by subject
    slots_by_subject = slots_with_moodle.group_by(&:subject_name)

    slots_by_subject.each do |subject_name, slots|
      # Find moodle timeline for this user and subject
      moodle_timeline = user.moodle_timelines
        .joins(:subject)
        .where(subjects: { name: subject_name })
        .first

      next unless moodle_timeline&.subject # Skip if no moodle timeline or no subject

      # Get selected topic names for this subject
      selected_topic_names = slots.map(&:topic_name).compact.uniq

      # Find all moodle topics that match the selected topic names
      selected_topics = moodle_timeline.moodle_topics.where(hidden: false)
        .where(name: selected_topic_names)

      next if selected_topics.empty?

      # Find the last (highest order) selected topic
      last_topic = selected_topics.order(order: :desc).first

      next unless last_topic

      # Get all moodle topics for this timeline ordered by order (ascending)
      all_topics = moodle_timeline.moodle_topics.where(hidden: false).order(order: :asc)

      # Collect topics from last_topic backwards (to lower order) until we reach a done topic
      topics_to_sum = []
      collecting = false

      all_topics.reverse.each do |topic|
        # Start collecting from the last selected topic
        if topic.id == last_topic.id
          topics_to_sum << topic
          collecting = true
          next
        end

        # If we've started collecting, continue until we hit a done topic
        if collecting
          # Stop when we encounter a done topic with lower order than last_topic
          break if topic.done? && topic.order < last_topic.order
          topics_to_sum << topic
        end
      end

      # Sum the time for all collected topics
      total_hours += topics_to_sum.sum(&:time)
    end

    # Update expected_hours without triggering callbacks
    update_column(:expected_hours, total_hours)
  end

  private

  def associate_existing_attendances
    # Associate existing attendances for this week with this weekly goal
    user.attendances
        .where("attendance_date >= ? AND attendance_date <= ?", week.start_date, week.end_date)
        .where(weekly_goal_id: nil)
        .update_all(weekly_goal_id: id)
  end

end
