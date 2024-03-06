# app/services/timeline_service.rb

class TimelineService
  attr_reader :timeline, :user

  def initialize(timeline)
    @timeline = timeline
    @user = timeline.user
  end

  def generate_topic_deadlines
    timeline_array = (timeline.start_date...timeline.end_date).to_a
    holidays_array = user.holidays.map { |holiday| (holiday.start_date..holiday.end_date).to_a }.flatten
    working_days = timeline_array.reject { |date| holidays_array.include?(date) || date.saturday? || date.sunday? }

    total_working_days = working_days.count
    cumulative_days = 0

    user.user_topics.where(topic: timeline.subject.topics).each do |user_topic|
      percentage_of_total = user_topic.topic.time.to_f / timeline.subject.topics.sum(:time)
      days_allocated = (percentage_of_total * total_working_days).round
      deadline_date = working_days[[cumulative_days + days_allocated - 1, total_working_days - 1].min]

      user_topic.update(deadline: deadline_date)
      cumulative_days += days_allocated
    end
  end

  def setup_new_timeline
    timeline.subject.topics.each do |topic|
      UserTopic.create!(user_id: user.id, topic_id: topic.id)
    end
    generate_topic_deadlines
    # Add any additional setup steps here
  end

  def update_timeline
    # Recalculate metrics or perform updates as needed
    generate_topic_deadlines
    # Add any additional update logic here
  end

  def self.update_timelines!(timelines)
    timelines.each do |timeline|
      new(timeline).update_timeline
    end
  end
end
