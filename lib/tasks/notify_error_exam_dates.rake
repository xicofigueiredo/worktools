namespace :timelines do
  desc "Validate timelines, notify users about issues, and send notification summaries via email"
  task notify_error_exam_dates: :environment do
    updated_count = 0
    notified_count = 0

    # Fetch all timelines with an exam_date_id
    timelines = Timeline.where.not(exam_date_id: nil).where(hidden: false)

    timelines.find_each do |timeline|
      # Fetch the associated exam_date
      exam_date = ExamDate.find_by(id: timeline.exam_date_id)
      next unless exam_date # Skip if the exam_date does not exist
      next if exam_date.date < Date.today # Skip if the exam_date is in the past

      # Check if the subject_id matches
      if exam_date.subject_id != timeline.subject_id
        # Attempt to find a corrected exam_date
        corrected_exam_date = ExamDate.find_by(
          subject_id: timeline.subject_id,
          date: exam_date.date # Match exact date
        )

        if corrected_exam_date
          # Update the timeline to use the corrected exam_date_id
          timeline.update(exam_date_id: corrected_exam_date.id)
          updated_count += 1
          puts "Updated timeline #{timeline.id} - #{timeline.subject.name} to exam_date ID #{corrected_exam_date.id}."
        else
          # Notify the user about the mismatch if no corrected exam_date exists
          Notification.find_or_create_by!(
            user: timeline.user,
            message: "Your timeline '#{timeline.subject.name}' has an exam date that doesn’t exist. Please update your timeline as soon as possible to ensure you're able to sit for the exams. Failure to update will result in being unable to take the exams."
          )
          notified_count += 1
          puts "Notified user #{timeline.user.full_name} about timeline #{timeline.id}."
        end
      end
    end

    puts "Step 1 Completed: #{updated_count} timelines were updated."
    puts "#{notified_count} users were notified about mismatched exam dates with no corrections available."

    # Step 2: Notify users about non-compliant timelines
    non_compliant_notifications_count = 0

    User.where(role: 'learner').find_each do |user|
      non_compliant_timelines = non_compliant_timelines(user)

      non_compliant_timelines.each do |timeline|
        Notification.find_or_create_by!(
          user: user,
          message: "Your timeline '#{timeline.subject.name}' has an invalid end date. Please update it to avoid issues with your exam schedule."
        )
        non_compliant_notifications_count += 1
      end
    end

    puts "Step 2 Completed: #{non_compliant_notifications_count} notifications created for non-compliant timelines."
  end

  # Helper method to find non-compliant timelines
  def non_compliant_timelines(user)
    user.timelines.select do |timeline|
      next unless timeline.exam_date

      expected_end_date = case timeline.exam_date.date.month
                          when 5, 6 # May/June exams
                            Date.new(timeline.exam_date.date.year, 2, 28)
                          when 10, 11 # October/November exams
                            Date.new(timeline.exam_date.date.year, 7, 28)
                          when 1 # January exams
                            Date.new(timeline.exam_date.date.year - 1, 10, 28) # Previous year for October
                          else
                            nil
                          end

      expected_end_date && timeline.end_date > expected_end_date
    end
  end
end
