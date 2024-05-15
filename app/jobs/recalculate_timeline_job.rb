# app/jobs/recalculate_timeline_job.rb
class RecalculateTimelineJob < ApplicationJob
  queue_as :default

  def perform(timeline_id)
    timeline = Timeline.find(timeline_id)
    generate_topic_deadlines(timeline)
    assign_mock_deadlines(timeline)
    timeline.calculate_total_time
    timeline.save
  end

  private

  def generate_topic_deadlines(timeline)
    subject = timeline.subject
    user_topics = subject.topics.map do |topic|
      timeline.user.user_topics.find_or_initialize_by(topic: topic)
    end

    working_days = calculate_working_days(timeline)
    distribute_deadlines(user_topics, working_days)
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
    final_index = index + time_per_topic
    working_days[final_index] || working_days.last
  end

  def assign_mock_deadlines(timeline)
    mock50_topic = timeline.subject.topics.find_by(Mock50: true)
    timeline.mock50 = timeline.user.user_topics.find_by(topic: mock50_topic)&.deadline if mock50_topic

    mock100_topic = timeline.subject.topics.find_by(Mock100: true)
    timeline.mock100 = timeline.user.user_topics.find_by(topic: mock100_topic)&.deadline if mock100_topic

    timeline.save
  end
end
