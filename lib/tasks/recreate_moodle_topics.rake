namespace :moodle do
  desc "Delete all moodle topics and recreate them"
  task recreate_topics: :environment do
    puts "Starting moodle topics recreation..."

    # Count existing topics before processing
    initial_count = MoodleTopic.count
    puts "Found #{initial_count} existing moodle topics"

    # Get all moodle timelines to recreate topics (excluding hidden ones)
    timelines = MoodleTimeline.includes(:user, :subject).where(hidden: false)
    puts "Found #{timelines.count} moodle timelines to process"
    puts "Processing each timeline individually for safe interruption...\n"

    processed_count = 0
    error_count = 0
    total_deleted = 0
    total_created = 0

    timelines.find_each.with_index do |timeline, index|
      begin
        user_name = timeline.user&.full_name || "Unknown User"
        subject_name = timeline.subject&.name || "Unknown Subject"

        puts "[#{index + 1}/#{timelines.count}] Processing timeline #{timeline.id} (User: #{user_name}, Subject: #{subject_name})"

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
        puts "  ✗ Error processing timeline #{timeline.id}: #{e.message}"
        puts "    Rolling back changes for this timeline and continuing..."
      end

      # Show progress every 10 timelines or at the end
      if (index + 1) % 10 == 0 || (index + 1) == timelines.count
        puts "  Progress: #{processed_count}/#{timelines.count} completed, #{error_count} errors\n"
      end
    end

    # Final summary
    final_count = MoodleTopic.count
    puts "="*60
    puts "Recreation completed!"
    puts "Timelines processed: #{processed_count}/#{timelines.count}"
    puts "Errors encountered: #{error_count}"
    puts "Topics deleted: #{total_deleted}"
    puts "Topics created: #{total_created}"
    puts "Initial total count: #{initial_count}"
    puts "Final total count: #{final_count}"
    puts "Net change: #{final_count - initial_count > 0 ? '+' : ''}#{final_count - initial_count}"

    if error_count > 0
      puts "\n⚠️  Some timelines had errors. Successfully processed timelines"
      puts "   remain in a consistent state and can be safely resumed."
    else
      puts "\n✅ All timelines processed successfully!"
    end
    puts "="*60
  end
end
