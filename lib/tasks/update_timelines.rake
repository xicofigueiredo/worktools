require './app/controllers/concerns/working_days_and_holidays'
require './app/controllers/concerns/generate_topic_deadlines'
require './app/controllers/concerns/progress_calculations'
# lib/tasks/simulate_update.rake
include GenerateTopicDeadlines
include ProgressCalculations

namespace :timelines do
  desc "update moodle timelines"
  task update_timelines: :environment do
    puts "Enter the subject id: "
    id = STDIN.gets.chomp.to_i
    puts "You entered: #{id}"
    puts "Are you sure you want to update timelines for subject id #{id}? (y/n)"
    confirm = STDIN.gets.chomp
    if confirm == "y"
      puts "Updating timelines for subject id #{id}..."
    end
    if confirm == "n"
      puts "Exiting..."
      exit
    end
    timelines = Timeline.where(hidden: false, subject_id: id)

    successful_updates = 0
    failed_updates = 0
    failed_timeline_ids = []

    puts "processing #{timelines.count} timelines..."

    timelines.each do |timeline|
      next if timeline.user.deactivate == true || timeline.user_topics.count == timeline.subject.topics.count
      begin
        puts "🔄 processing timeline id #{timeline.id}..."
        generate_topic_deadlines(timeline)
        calculate_progress_and_balance([timeline])

        # find an appropriate exam date for this timeline's subject
        # look for exam dates that are after the timeline's end date
        # suitable_exam_date = examdate.where(subject_id: timeline.subject_id)
        #                             .where('date > ?', timeline.end_date)
        #                             .order(:date)
        #                             .first

        # if suitable_exam_date
        #   timeline.exam_date = suitable_exam_date
        #   timeline.save! # explicitly save
        #   puts "📅 set exam date: #{suitable_exam_date.date} for timeline id #{timeline.id}"
        # else
        #   puts "⚠️  no suitable exam date found for timeline id #{timeline.id} (subject: #{timeline.subject.name})"
        # end

        successful_updates += 1
        puts "✅ timeline id #{timeline.id} updated successfully"
      rescue ActiveRecord::RecordInvalid => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ timeline id #{timeline.id} failed: #{e.message}"
        puts "   start date: #{timeline.start_date}, end date: #{timeline.end_date}"
        puts "   validation errors: #{timeline.errors.full_messages.join(', ')}"
      rescue => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ timeline id #{timeline.id} failed with unexpected error: #{e.message}"
      end
    end

    puts "\n=== summary ==="
    puts "total timelines processed: #{timelines.count}"
    puts "successful updates: #{successful_updates}"
    puts "failed updates: #{failed_updates}"

    if failed_timeline_ids.any?
      puts "\nfailed timeline ids:"
      puts failed_timeline_ids.join(", ")

      puts "\nto investigate specific timelines:"
      failed_timeline_ids.each do |id|
        puts "timeline.find(#{id}).errors.full_messages"
      end
    end

    # puts "timelines that have no exam date set:"
    # count = 0
    # timelines.each do |timeline|
    #   next if timeline.user.deactivate == true
    #   next if timeline.subject.category.in?(['lws7', 'lws8', 'lws9', 'up', 'other'])  # skip lower secondary
    #   puts " #{timeline.end_date} - #{timeline.subject&.name} (#{timeline.user&.email})"
    #   count += 1
    # end
    # puts "total: #{count}"
  end
end
