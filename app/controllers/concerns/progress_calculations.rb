module ProgressCalculations
  extend ActiveSupport::Concern

  # Preload user_topics for all topics across timelines once and then compute progress.
  def calculate_progress_and_balance(timelines)
    # Collect all topic IDs from all timelines’ subjects (using in-memory associations if already loaded)
    all_topic_ids = timelines.flat_map { |timeline| timeline.subject.topics.map(&:id) }.uniq

    # Preload user_topics for current_user for these topics in one query, index by topic_id
    user_topics_by_topic = current_user.user_topics.where(topic_id: all_topic_ids).index_by(&:topic_id)

    timelines.each do |timeline|
      topics = timeline.subject.topics
      total_topics = topics.size

      if timeline.lws_timeline.nil?
        # For non-LWS timelines, accumulate values in one pass
        result = topics.each_with_object({ balance: 0, progress: 0.0, expected: 0.0 }) do |topic, h|
          ut = user_topics_by_topic[topic.id]
          next unless ut

          # Update balance based on deadline and done state
          if ut.done && ut.deadline && ut.deadline >= Date.today
            h[:balance] += 1
          elsif !ut.done && ut.deadline && ut.deadline < Date.today
            h[:balance] -= 1
          end

          # Sum progress if topic is done
          h[:progress] += ut.percentage if ut.done
          # Sum expected progress if deadline has passed
          h[:expected] += ut.percentage if ut.deadline && ut.deadline < Date.today
        end

        balance = result[:balance]
        progress = result[:progress]
        expected_progress = result[:expected]
      else
        # For LWS timelines, calculate expected completions based on days passed
        days_passed = (Date.today - timeline.start_date).to_i
        expected = (timeline.lws_timeline.blocks_per_day * days_passed).to_i

        # Count how many topics are done
        actual = topics.count { |topic| user_topics_by_topic[topic.id]&.done }
        balance = actual - expected

        # Sum percentages for done topics in one pass
        progress = topics.sum { |topic| user_topics_by_topic[topic.id]&.done ? user_topics_by_topic[topic.id].percentage : 0.0 }
        expected_progress = total_topics.positive? ? (expected.to_f / total_topics) : 0.0
      end

      # Convert progress values into whole percentages
      progress_percentage = (progress * 100).round
      expected_progress_percentage = (expected_progress * 100).round

      # Update the timeline record (this is a DB update per timeline)
      timeline.update(
        balance: balance,
        progress: progress_percentage,
        expected_progress: expected_progress_percentage
      )
    end
  end

  def moodle_calculate_progress_and_balance(timelines)

    timelines.each do |timeline|
      topics = timeline.moodle_topics
      total_topics = topics.size
      progress = 0
      balance = 0
      expected_progress = 0
      total_time = timeline.moodle_topics.sum(:time).to_f

      topics.each do |topic|
        # Update balance based on deadline and done state
        if topic.done && topic.deadline && topic.deadline >= Date.today
          balance += 1
        elsif !topic.done && topic.deadline && topic.deadline < Date.today
          balance -= 1
        end
        percentage = topic.time / total_time if topic.time.positive? && total_time.positive?

        # Sum progress if topic is done
        progress += percentage if topic.done && !percentage.nil?
        # Sum expected progress if deadline has passed
        expected_progress += percentage if topic.deadline && topic.deadline < Date.today && !percentage.nil?
      end


      # Convert progress values into whole percentages
      progress_percentage = (progress * 100).round
      expected_progress_percentage = (expected_progress * 100).round

      # Update the timeline record (this is a DB update per timeline)
      timeline.update(
        balance: balance,
        progress: progress_percentage,
        expected_progress: expected_progress_percentage
      )
    end
  end

  # Refactored to preload user_topics for the given timeline to avoid N+1 queries
  def calc_remaining_blocks(timeline)
    topics = timeline.subject.topics
    topic_ids = topics.map(&:id)
    user_topics = current_user.user_topics.where(topic_id: topic_ids).index_by(&:topic_id)
    topics.count { |topic| user_topics[topic.id] && !user_topics[topic.id].done }
  end

  def calc_remaining_timeline_hours_and_percentage(timeline)
    topics = timeline.subject.topics
    topic_ids = topics.map(&:id)
    user_topics = current_user.user_topics.where(topic_id: topic_ids).index_by(&:topic_id)

    remaining_hours_count = 0
    remaining_percentage = 0.0

    topics.each do |topic|
      ut = user_topics[topic.id]
      next unless ut && !ut.done

      remaining_hours_count += topic.time
      remaining_percentage += ut.percentage
    end

    [remaining_hours_count, remaining_percentage]
  end

  def moodle_calc_remaining_timeline_hours_and_percentage(timeline)
    topics = timeline.moodle_topics

    remaining_hours_count = 0
    remaining_percentage = 0.0

    topics.each do |topic|
      next unless topic && topic.done

      remaining_hours_count += topic.time
      remaining_percentage += topic.percentage
    end

    [remaining_hours_count, remaining_percentage]
  end

  def calc_array_average(array)
    array.sum.to_f / array.size
  end
end
