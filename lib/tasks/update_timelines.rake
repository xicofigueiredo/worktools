require './app/controllers/concerns/working_days_and_holidays'
require './app/controllers/concerns/generate_topic_deadlines'
# lib/tasks/simulate_update.rake

class TimelineUpdater
  include GenerateTopicDeadlines
  include WorkingDaysAndHolidays

  def update_timeline(timeline)

    assign_mock_deadlines(timeline)
    timeline.save!
  end
end

namespace :timelines do
  desc "Update timelines where mock50 and mock100 are not set"
  task simulate_update: :environment do
    timelines = Timeline.where(user: 620, hidden: false)
    calculate_progress_and_balance(timelines)
  end
end
