module GenerateTopicDeadlines
  extend ActiveSupport::Concern
  include WorkingDaysAndHolidays


  def generate_topic_deadlines(timeline)
    subject = timeline.subject
    user_topics = subject.topics.order(:order).map do |topic|
      current_user.user_topics.find_or_initialize_by(topic: topic)
    end

    working_days = calculate_working_days(timeline)

    distribute_deadlines(user_topics, working_days)
    assign_mock_deadlines(timeline)
  end

  def distribute_deadlines(user_topics, working_days)
    total_time = working_days.count
    index = 0

    user_topics.each do |user_topic|
      time_per_topic = (user_topic.calculate_percentage * total_time)
      deadline_date = calculate_deadline_date(index, time_per_topic, working_days, total_time)
      user_topic.deadline = deadline_date
      user_topic.save if user_topic.changed?
      index += time_per_topic
    end
  end

  def calculate_deadline_date(index, time_per_topic, working_days, total_time)
    # Ensure index does not exceed the bounds of working days
    final_index = index + time_per_topic
    working_days[final_index] || working_days.last
  end

  def assign_mock_deadlines(timeline)
    # Assign mock50 value
    mock50_topic = timeline.subject.topics.find_by(Mock50: true)
    timeline.mock50 = timeline.user.user_topics.find_by(topic: mock50_topic)&.deadline if mock50_topic

    # Assign mock100 value
    mock100_topic = timeline.subject.topics.find_by(Mock100: true)
    timeline.mock100 = timeline.user.user_topics.find_by(topic: mock100_topic)&.deadline if mock100_topic

    # Prevent loop by using a flag
    timeline.save
  end
end
