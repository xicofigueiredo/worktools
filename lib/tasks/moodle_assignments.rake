namespace :moodle_assignments do
  desc "Calculate grading_time for all Moodle assignments"
  task calculate_grading_time: :environment do
    puts "Calculating grading_time for all Moodle assignments..."
    total = MoodleAssignment.count
    processed = 0
    errors = 0

    MoodleAssignment.find_each do |assignment|
      begin
        assignment.recalculate_grading_time!
        processed += 1
        if processed % 10 == 0
          puts "Processed #{processed}/#{total} assignments..."
        end
      rescue => e
        errors += 1
        puts "Error calculating grading_time for assignment #{assignment.id}: #{e.message}"
      end
    end

    puts "Done! Processed: #{processed}, Errors: #{errors}"
  end

  desc "Update submission_date for all submissions using timemodified from Moodle API"
  task update_submission_dates: :environment do
    puts "Updating submission_date for all submissions using timemodified..."
    service = MoodleApiService.new
    updated = 0
    errors = 0

    # Group submissions by assignment to minimize API calls
    MoodleAssignment.includes(:submissions).find_each do |assignment|
      next if assignment.submissions.empty?
      next unless assignment.moodle_id.present?

      begin
        # Fetch fresh submissions data from Moodle
        result = service.call('mod_assign_get_submissions', { assignmentids: [assignment.moodle_id] })
        next unless result['assignments']&.any?

        assignment_data = result['assignments'].first
        api_submissions = (assignment_data['submissions'] || []).index_by { |s| s['id'] }

        # Update each submission's submission_date using timemodified
        assignment.submissions.find_each do |submission|
          api_sub = api_submissions[submission.moodle_submission_id.to_i]
          next unless api_sub

          new_date = api_sub['timemodified'].to_i > 0 ? Time.at(api_sub['timemodified'].to_i) : nil
          if submission.submission_date != new_date
            submission.update_column(:submission_date, new_date)
            updated += 1
          end
        end

        puts "Updated assignment #{assignment.id} (#{assignment.name})"
      rescue => e
        errors += 1
        puts "Error updating submissions for assignment #{assignment.id}: #{e.message}"
      end
    end

    puts "Done! Updated: #{updated} submissions, Errors: #{errors}"
  end
end
