namespace :exam_enrolls do
  desc 'Update exam enrolls with qualification, board and code from associated timeline subject'
  task update_exam_enroll_data: :environment do
    puts "Starting to update exam enrolls with subject data from timelines..."

    # Find all exam enrolls that have a timeline associated
    exam_enrolls = ExamEnroll.includes(timeline: :subject)
                            .where.not(timeline_id: nil)
                            .joins(timeline: :subject)

    puts "Found #{exam_enrolls.count} exam enrolls with associated timelines"

    updated_count = 0
    errors_count = 0

    exam_enrolls.find_each do |exam_enroll|
      timeline = exam_enroll.timeline
      subject = timeline.subject

      puts "\nProcessing exam enroll ID: #{exam_enroll.id}"
      puts "  Timeline: #{timeline.id} - Subject: #{subject.name}"

      # Store the original values for comparison
      original_qualification = exam_enroll.qualification
      original_board = exam_enroll.exam_board
      original_code = exam_enroll.code

      # Update with subject data
      exam_enroll.qualification = subject.qualification
      exam_enroll.exam_board = subject.board
      exam_enroll.code = subject.code

      begin
        if exam_enroll.save
          updated_count += 1
          puts "  ✓ Updated successfully:"
          puts "    Qualification: '#{original_qualification}' → '#{subject.qualification}'"
          puts "    Board: '#{original_board}' → '#{subject.board}'"
          puts "    Code: '#{original_code}' → '#{subject.code}'"
        else
          errors_count += 1
          puts "  ✗ Failed to save: #{exam_enroll.errors.full_messages.join(', ')}"
        end
      rescue => e
        errors_count += 1
        puts "  ✗ Error occurred: #{e.message}"
      end
    end

    puts "\n" + "="*50
    puts "Update completed!"
    puts "Total exam enrolls processed: #{exam_enrolls.count}"
    puts "Successfully updated: #{updated_count}"
    puts "Errors: #{errors_count}"
    puts "="*50
  end
end
