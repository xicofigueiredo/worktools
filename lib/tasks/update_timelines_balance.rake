require './app/controllers/concerns/progress_calculations'

include ProgressCalculations

namespace :timelines do
  desc "Update balance count for all timelines"
  task update_balance: :environment do
    timelines = Timeline.where(hidden: false)
                        .includes(:user, subject: :topics)

    successful_updates = 0
    failed_updates = 0
    failed_timeline_ids = []

    puts "Processing #{timelines.count} timelines for balance update..."

    # Process timelines in batches to avoid memory issues
    timelines.find_each(batch_size: 100) do |timeline|
      next if timeline.user.deactivate == true

      begin
        puts "🔄 Processing Timeline ID #{timeline.id} (User: #{timeline.user.email}, Subject: #{timeline.subject.name})..."

        # Calculate and update balance (this also updates progress and expected_progress)
        calculate_progress_and_balance([timeline])

        # Reload to get the updated balance
        timeline.reload

        successful_updates += 1
        puts "✅ Timeline ID #{timeline.id} balance updated: #{timeline.balance}"
      rescue ActiveRecord::RecordInvalid => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ Timeline ID #{timeline.id} failed: #{e.message}"
        puts "   Validation errors: #{timeline.errors.full_messages.join(', ')}"
      rescue => e
        failed_updates += 1
        failed_timeline_ids << timeline.id
        puts "❌ Timeline ID #{timeline.id} failed with unexpected error: #{e.message}"
        puts "   Backtrace: #{e.backtrace.first(3).join("\n   ")}"
      end
    end

    puts "\n=== SUMMARY (Timeline) ==="
    puts "Total timelines processed: #{timelines.count}"
    puts "Successful updates: #{successful_updates}"
    puts "Failed updates: #{failed_updates}"

    if failed_timeline_ids.any?
      puts "\nFailed Timeline IDs:"
      puts failed_timeline_ids.join(", ")

      puts "\nTo investigate specific timelines:"
      failed_timeline_ids.each do |id|
        puts "  Timeline.find(#{id}).errors.full_messages"
      end
    end

    # Show balance statistics
    puts "\n=== BALANCE STATISTICS (Timeline) ==="
    updated_timelines = Timeline.where(id: timelines.pluck(:id))
    positive_balance = updated_timelines.where("balance > 0").count
    negative_balance = updated_timelines.where("balance < 0").count
    zero_balance = updated_timelines.where(balance: 0).count

    puts "Timelines with positive balance: #{positive_balance}"
    puts "Timelines with negative balance: #{negative_balance}"
    puts "Timelines with zero balance: #{zero_balance}"
    puts "Average balance: #{updated_timelines.average(:balance)&.round(2) || 0}"
  end

  desc "Update balance count for all Moodle timelines"
  task update_moodle_balance: :environment do
    moodle_timelines = MoodleTimeline.where(hidden: false)
                                      .includes(:user, :subject)

    successful_updates = 0
    failed_updates = 0
    failed_timeline_ids = []

    puts "Processing #{moodle_timelines.count} Moodle timelines for balance update..."

    # Process timelines in batches to avoid memory issues
    moodle_timelines.find_each(batch_size: 100) do |moodle_timeline|
      next if moodle_timeline.user.deactivate == true

      begin
        puts "🔄 Processing MoodleTimeline ID #{moodle_timeline.id} (User: #{moodle_timeline.user.email}, Subject: #{moodle_timeline.subject.name})..."

        # Calculate and update balance (this also updates progress and expected_progress)
        moodle_calculate_progress_and_balance([moodle_timeline])

        # Reload to get the updated balance
        moodle_timeline.reload

        successful_updates += 1
        puts "✅ MoodleTimeline ID #{moodle_timeline.id} balance updated: #{moodle_timeline.balance}"
      rescue ActiveRecord::RecordInvalid => e
        failed_updates += 1
        failed_timeline_ids << moodle_timeline.id
        puts "❌ MoodleTimeline ID #{moodle_timeline.id} failed: #{e.message}"
        puts "   Validation errors: #{moodle_timeline.errors.full_messages.join(', ')}"
      rescue => e
        failed_updates += 1
        failed_timeline_ids << moodle_timeline.id
        puts "❌ MoodleTimeline ID #{moodle_timeline.id} failed with unexpected error: #{e.message}"
        puts "   Backtrace: #{e.backtrace.first(3).join("\n   ")}"
      end
    end

    puts "\n=== SUMMARY (MoodleTimeline) ==="
    puts "Total Moodle timelines processed: #{moodle_timelines.count}"
    puts "Successful updates: #{successful_updates}"
    puts "Failed updates: #{failed_updates}"

    if failed_timeline_ids.any?
      puts "\nFailed MoodleTimeline IDs:"
      puts failed_timeline_ids.join(", ")

      puts "\nTo investigate specific Moodle timelines:"
      failed_timeline_ids.each do |id|
        puts "  MoodleTimeline.find(#{id}).errors.full_messages"
      end
    end

    # Show balance statistics
    puts "\n=== BALANCE STATISTICS (MoodleTimeline) ==="
    updated_timelines = MoodleTimeline.where(id: moodle_timelines.pluck(:id))
    positive_balance = updated_timelines.where("balance > 0").count
    negative_balance = updated_timelines.where("balance < 0").count
    zero_balance = updated_timelines.where(balance: 0).count

    puts "MoodleTimelines with positive balance: #{positive_balance}"
    puts "MoodleTimelines with negative balance: #{negative_balance}"
    puts "MoodleTimelines with zero balance: #{zero_balance}"
    puts "Average balance: #{updated_timelines.average(:balance)&.round(2) || 0}"
  end

  desc "Update balance count for all timelines (both Timeline and MoodleTimeline)"
  task update_all_balance: :environment do
    puts "=" * 60
    puts "Updating balance for regular timelines..."
    puts "=" * 60
    Rake::Task["timelines:update_balance"].invoke

    puts "\n" + "=" * 60
    puts "Updating balance for Moodle timelines..."
    puts "=" * 60
    Rake::Task["timelines:update_moodle_balance"].invoke
  end
end
