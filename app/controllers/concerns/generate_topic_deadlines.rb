module GenerateTopicDeadlines
  extend ActiveSupport::Concern
  include WorkingDaysAndHolidays

  def generate_topic_deadlines(timeline)
    subject = timeline.subject
    # Preload all topics in order and their corresponding user_topics for the current user.
    topic_ids = subject.topics.order(:order).pluck(:id)
    user_topics_by_id = current_user.user_topics.where(topic_id: topic_ids).index_by(&:topic_id)

    # Build an array of user_topics; if not found, build a new one.
    user_topics = subject.topics.order(:order).map do |topic|
      user_topics_by_id[topic.id] || current_user.user_topics.build(topic: topic)
    end

    working_days = calculate_working_days(timeline)
    distribute_deadlines(user_topics, working_days)
    assign_mock_deadlines(timeline)
  end

  def distribute_deadlines(user_topics, working_days)
    total_working_days = working_days.size
    index = 0.0

    user_topics.each do |user_topic|
      # Calculate how many working days this topic should take
      time_per_topic = user_topic.calculate_percentage * total_working_days
      deadline_date = calculate_deadline_date(index, time_per_topic, working_days)
      user_topic.deadline = deadline_date
      user_topic.save if user_topic.changed?
      index += time_per_topic
    end
  end

  def calculate_deadline_date(index, time_per_topic, working_days)
    # Calculate the final index (convert to integer for array indexing)
    final_index = (index + time_per_topic).to_i
    working_days[final_index] || working_days.last
  end

  def assign_mock_deadlines(timeline)
    # Assign mock50 deadline
    if (mock50_topic = timeline.subject.topics.find_by(Mock50: true))
      timeline.mock50 = timeline.user.user_topics.find_by(topic: mock50_topic)&.deadline
    end

    # Assign mock100 deadline
    if (mock100_topic = timeline.subject.topics.find_by(Mock100: true))
      timeline.mock100 = timeline.user.user_topics.find_by(topic: mock100_topic)&.deadline
    end

    timeline.save
  end
end
