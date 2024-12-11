namespace :timeline do
  desc "Validate and update timeline.exam_date_id to match the correct subject_id"
  task fix_exam_dates: :environment do
    updated_count = 0

    # Fetch all timelines with an exam_date_id
    timelines = Timeline.where.not(exam_date_id: nil)

    timelines.find_each do |timeline|
      # Fetch the associated exam_date
      exam_date = ExamDate.find_by(id: timeline.exam_date_id)
      next unless exam_date # Skip if the exam_date does not exist

      # Check if the subject_id matches
      if exam_date.subject_id != timeline.subject_id
        # Find an exam date with the exact same date for the correct subject_id
        corrected_exam_date = ExamDate.find_by(
          subject_id: timeline.subject_id,
          date: exam_date.date # Match exact date
        )

        if corrected_exam_date
          # Update the timeline to use the corrected exam_date_id
          timeline.update(exam_date_id: corrected_exam_date.id)
          updated_count += 1
          puts "Updated timeline #{timeline.id} - #{timeline.subject.name} to exam_date ID #{corrected_exam_date.id}."
        end
      end
    end

    puts "Completed. #{updated_count} timelines were updated."
  end
end
