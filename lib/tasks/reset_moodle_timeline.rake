

namespace :moodle_timelines do
  desc "Reset all moodle timelines by deleting and recreating them with same start date, end date, and exam season"
  task reset: :environment do
    puts "Starting moodle timeline reset..."

    # Check if Moodle API is configured
    moodle_api_configured = ENV['MOODLE_API_BASE_URL'].present? && ENV['MOODLE_API_TOKEN'].present?

    if moodle_api_configured
      puts "✓ Moodle API is configured - will populate topics via API"
    else
      puts "⚠ Moodle API not configured - will create empty timelines without topics"
      puts "  Set MOODLE_API_BASE_URL and MOODLE_API_TOKEN environment variables for full functionality"
    end

    processed_count = 0
    total_count = MoodleTimeline.count
    puts "Found #{total_count} timelines to reset"

    # Process each timeline individually to ensure no gaps in availability
    MoodleTimeline.includes(:exam_date, :user, :subject).find_each do |timeline|
      begin
        # Extract data from current timeline
        data = {
          user_id: timeline.user_id,
          subject_id: timeline.subject_id,
          start_date: timeline.start_date,
          end_date: timeline.end_date,
          exam_date_id: timeline.exam_date_id,
          category: timeline.category,
          moodle_id: timeline.moodle_id,
          hidden: timeline.hidden,
          as1: timeline.as1,
          as2: timeline.as2,
          blocks: timeline.blocks
        }

        # Log the exam season for verification
        exam_season = if timeline.exam_date.present?
                        timeline.exam_date.date.strftime("%B %Y")
                      else
                        'N/A'
                      end

        old_timeline_id = timeline.id
        subject_name = timeline.subject&.name || 'N/A'

        puts "Processing timeline ID: #{old_timeline_id} for User ID: #{data[:user_id]}, Subject: #{subject_name}, Exam Season: #{exam_season}"

        # Delete the current timeline
        timeline.destroy!

        if moodle_api_configured
          # Create with API calls enabled (normal creation)
          new_timeline = MoodleTimeline.create!(
            user_id: data[:user_id],
            subject_id: data[:subject_id],
            start_date: data[:start_date],
            end_date: data[:end_date],
            exam_date_id: data[:exam_date_id],
            category: data[:category],
            moodle_id: data[:moodle_id],
            hidden: data[:hidden] || false,
            as1: data[:as1],
            as2: data[:as2],
            blocks: data[:blocks],
            # Initialize other fields with default values
            balance: 0,
            expected_progress: 0,
            progress: 0,
            total_time: 0,
            difference: 0
          )
        else
          # Create without API calls (skip callbacks)
          new_timeline = MoodleTimeline.new(
            user_id: data[:user_id],
            subject_id: data[:subject_id],
            start_date: data[:start_date],
            end_date: data[:end_date],
            exam_date_id: data[:exam_date_id],
            category: data[:category],
            moodle_id: data[:moodle_id],
            hidden: data[:hidden] || false,
            as1: data[:as1],
            as2: data[:as2],
            blocks: data[:blocks],
            # Initialize other fields with default values
            balance: 0,
            expected_progress: 0,
            progress: 0,
            total_time: 0,
            difference: 0
          )
          new_timeline.save!(validate: false)
        end

        puts "✓ Replaced timeline ID: #{old_timeline_id} → #{new_timeline.id} (User: #{data[:user_id]}, Subject: #{subject_name}, Exam Season: #{exam_season})"
        processed_count += 1

      rescue => e
        puts "✗ Error processing timeline ID: #{timeline&.id} for User ID: #{timeline&.user_id}: #{e.message}"
        puts "  Continuing with next timeline..."
      end
    end

    puts "Successfully reset #{processed_count}/#{total_count} moodle timelines"

    if moodle_api_configured
      puts "✓ Timelines created with Moodle topics populated via API"
    else
      puts "⚠ Timelines created without topics - configure Moodle API to populate topics"
    end

    puts "Reset complete!"
  end
end
