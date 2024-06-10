require '/Users/xico/code/xicofigueiredo/worktools/app/controllers/concerns/working_days_and_holidays'
require '/Users/xico/code/xicofigueiredo/worktools/app/controllers/concerns/generate_topic_deadlines'
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
    updater = TimelineUpdater.new
    Timeline.where(mock50: nil, mock100: nil).find_each do |timeline|
      begin
        updater.update_timeline(timeline)
        puts "Updated Timeline #{timeline.id}"
      rescue => e
        puts "Failed to update Timeline #{timeline.id}: #{e.message}"
      end
    end
  end
end
