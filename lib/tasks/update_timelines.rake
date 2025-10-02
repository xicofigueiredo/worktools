require './app/controllers/concerns/working_days_and_holidays'
require './app/controllers/concerns/generate_topic_deadlines'
# lib/tasks/simulate_update.rake

namespace :timelines do
  desc "Update timelines that have exam season nil"
  task simulate_update: :environment do
    timelines = Timeline.where(hidden: false, end_date: Date.today..Date.today + 3.year)
    array_of_timelines = timelines.to_a

    successful_updates = 0
    failed_updates = 0
    failed_timeline_ids = []

    puts "Processing #{timelines.count} timelines..."

    timelines.each do |timeline|
      next if timeline.user.deactivate == true
      begin
        puts "🔄 Processing Timeline ID #{timeline.id}..."
        generate_topic_deadlines(timeline)

        # Find an appropriate exam date for this timeline's subject
        # Look for exam dates that are after the timeline's end date
        # suitable_exam_date = ExamDate.where(subject_id: timeline.subject_id)
        #                             .where('date > ?', timeline.end_date)
        #                             .order(:date)
        #                             .first

        # if suitable_exam_date
        #   timeline.exam_date = suitable_exam_date
        #   timeline.save! # Explicitly save
        #   puts "📅 Set exam date: #{suitable_exam_date.date} for Timeline ID #{timeline.id}"
        # else
        #   puts "⚠️  No suitable exam date found for Timeline ID #{timeline.id} (Subject: #{timeline.subject.name})"
        # end

        successful_updates += 1
        puts "✅ Timeline ID #{timeline.id} updated successfully"
      rescue ActiveRecord::RecordInvalid => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ Timeline ID #{timeline.id} failed: #{e.message}"
        puts "   Start date: #{timeline.start_date}, End date: #{timeline.end_date}"
        puts "   Validation errors: #{timeline.errors.full_messages.join(', ')}"
      rescue => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ Timeline ID #{timeline.id} failed with unexpected error: #{e.message}"
      end
    end

    puts "\n=== SUMMARY ==="
    puts "Total timelines processed: #{timelines.count}"
    puts "Successful updates: #{successful_updates}"
    puts "Failed updates: #{failed_updates}"

    if failed_timeline_ids.any?
      puts "\nFailed Timeline IDs:"
      puts failed_timeline_ids.join(", ")

      puts "\nTo investigate specific timelines:"
      failed_timeline_ids.each do |id|
        puts "Timeline.find(#{id}).errors.full_messages"
      end
    end

    # puts "Timelines that have no exam date set:"
    # count = 0
    # timelines.each do |timeline|
    #   next if timeline.user.deactivate == true
    #   next if timeline.subject.category.in?(['lws7', 'lws8', 'lws9', 'up', 'other'])  # Skip lower secondary
    #   puts " #{timeline.end_date} - #{timeline.subject&.name} (#{timeline.user&.email})"
    #   count += 1
    # end
    puts "Total: #{count}"
  end
end
