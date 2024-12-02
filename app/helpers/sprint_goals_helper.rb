module SprintGoalsHelper
  def calculate_deadlines(timeline, sprint, current_user)
    last_relevant_topic = timeline.subject.topics.includes(:user_topics)
                                  .where(user_topics: { user_id: current_user.id })
                                  .select do |topic|
                                    user_topic = topic.user_topics.find { |ut| ut.user_id == current_user.id }
                                    user_topic&.deadline &&
                                      user_topic.deadline.between?(sprint.start_date, sprint.end_date)
                                  end
            .max_by { |topic| topic.user_topics.find { |ut| ut.user_id == current_user.id }.deadline }
    { topic: last_relevant_topic } if last_relevant_topic.present?
  end
end
