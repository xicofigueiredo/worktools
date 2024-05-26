module ProgressCalculations
  extend ActiveSupport::Concern

  def calculate_progress_and_balance(timelines)
    timelines.each do |timeline|
      balance = 0
      completed_topics_count = 0
      progress = 0
      expected_progress = 0

      topics = timeline.subject.topics
      total_topics = topics.count

      topics.each do |topic|
        user_topic = current_user.user_topics.find_by(topic_id: topic.id)
        next unless user_topic

        if timeline.lws_timeline != nil
          expected = (timeline.lws_timeline.blocks_per_day * (Date.today - timeline.start_date).to_f).to_i
          actual = current_user.user_topics.where(topic_id: topic.id, done: true).count
          balance = actual - expected

          completed_topics_count += 1 if user_topic.done
          progress += user_topic.percentage if user_topic.done
          expected_progress = (expected / total_topics)
        else
          if user_topic.done && user_topic.deadline && user_topic.deadline >= Date.today
            balance += 1
          elsif !user_topic.done && user_topic.deadline && user_topic.deadline < Date.today
            balance -= 1
          end

          completed_topics_count += 1 if user_topic.done
          progress += user_topic.percentage if user_topic.done
          expected_progress += user_topic.percentage if user_topic.deadline < Date.today
        end
      end

      progress = (progress.to_f * 100).round
      expected_progress_percentage = (expected_progress.to_f * 100).round

      timeline.update(balance: balance, progress: progress, expected_progress: expected_progress_percentage)
    end
  end

  def calc_remaining_blocks(timeline)
    topics = timeline.subject.topics
    remaining_topics_count = 0

    topics.each do |topic|
      user_topic = current_user.user_topics.find_by(topic_id: topic.id)
      remaining_topics_count += 1 if user_topic && !user_topic.done
    end

    remaining_topics_count
  end
end
