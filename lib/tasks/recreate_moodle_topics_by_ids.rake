namespace :moodle do
  desc "Delete and recreate moodle topics for specific timeline IDs"
  task recreate_topics_by_ids: :environment do
    # Define the array of moodle timeline IDs here
    timeline_ids = [
      17467
    ]

    if timeline_ids.empty?
      puts "❌ No timeline IDs provided. Please add timeline IDs to the timeline_ids array in the rake task."
      exit 1
    end

    puts "Starting moodle topics recreation for specific timelines..."
    puts "Timeline IDs to process: #{timeline_ids.join(', ')}"

    # Count existing topics before processing
    initial_count = MoodleTopic.count
    puts "Found #{initial_count} existing moodle topics"

    # Get the specific moodle timelines
    timelines = MoodleTimeline.includes(:user, :subject)
                              .where(id: timeline_ids)
                              .where(hidden: false)
                              .joins(:user)
                              .where(users: { deactivate: [false, nil] })
                              .where(users: { graduated_at: nil })

    found_timelines = timelines.count
    puts "Found #{found_timelines} valid moodle timelines to process"

    if found_timelines == 0
      puts "❌ No valid timelines found for the provided IDs"
      exit 1
    end

    puts "Processing each timeline individually for safe interruption...\n"

    processed_count = 0
    error_count = 0
    total_deleted = 0
    total_created = 0
    error_timeline_ids = []

    timelines.find_each.with_index do |timeline, index|
      begin
        user_name = timeline.user&.full_name || "Unknown User"
        subject_name = timeline.subject&.name || "Unknown Subject"

        puts "[#{index + 1}/#{found_timelines}] Processing timeline #{timeline.id} (User: #{user_name}, Subject: #{subject_name})"

        # Process each timeline in a transaction for consistency
        ActiveRecord::Base.transaction do
          # Count and delete only topics with moodle_id (from Moodle API)
          moodle_topics = timeline.moodle_topics.where.not(moodle_id: nil)
          manual_topics_count = timeline.moodle_topics.where(moodle_id: nil).count
          moodle_topics_count = moodle_topics.count

          if moodle_topics_count > 0
            moodle_topics.delete_all
            puts "  - Deleted #{moodle_topics_count} Moodle topics (preserved #{manual_topics_count} manual topics)"
            total_deleted += moodle_topics_count
          else
            puts "  - No Moodle topics to delete (#{manual_topics_count} manual topics preserved)"
          end

          # Call the create_moodle_topics method on this timeline
          timeline.create_moodle_topics

          # Count topics created for this timeline
          topics_created = timeline.moodle_topics.count
          puts "  ✓ Created #{topics_created} new topics"
          total_created += topics_created
        end

        processed_count += 1

      rescue => e
        error_count += 1
        error_timeline_ids << timeline.id
        puts "  ✗ Error processing timeline #{timeline.id}: #{e.message}"
        puts "    Rolling back changes for this timeline and continuing..."
      end

      # Show progress every 5 timelines or at the end
      if (index + 1) % 5 == 0 || (index + 1) == found_timelines
        puts "  Progress: #{processed_count}/#{found_timelines} completed, #{error_count} errors\n"
      end
    end

    # Final summary
    final_count = MoodleTopic.count
    puts "="*60
    puts "Recreation completed!"
    puts "Timelines processed: #{processed_count}/#{found_timelines}"
    puts "Errors encountered: #{error_count}"
    puts "Topics deleted: #{total_deleted}"
    puts "Topics created: #{total_created}"
    puts "Initial total count: #{initial_count}"
    puts "Final total count: #{final_count}"
    puts "Net change: #{final_count - initial_count > 0 ? '+' : ''}#{final_count - initial_count}"

    if error_count > 0
      puts "\n⚠️  Some timelines had errors:"
      puts "   Failed timeline IDs: #{error_timeline_ids.join(', ')}"
      puts "   Successfully processed timelines remain in a consistent state."
    else
      puts "\n✅ All timelines processed successfully!"
    end
    puts "="*60
  end
end
