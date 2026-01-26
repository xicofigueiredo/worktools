# Fix hub on exam registration

namespace :exam_enroll do
  desc "Check and fix hub mismatches on exam enrollments with future exam dates"
  task fix_hub: :environment do
    today = Date.today

    # Find all exam enrolls where the exam_date.date is after today
    future_exam_enrolls = ExamEnroll.joins(timeline: :exam_date)
                                    .where("exam_dates.date > ?", today)

    puts "Found #{future_exam_enrolls.count} exam enrollments with future exam dates"
    puts "-" * 60

    mismatches = []

    future_exam_enrolls.find_each do |exam_enroll|
      user = exam_enroll.timeline&.user
      next unless user

      main_hub = user.main_hub
      next unless main_hub

      current_hub = exam_enroll.hub
      expected_hub = main_hub.name

      if current_hub != expected_hub
        mismatches << {
          exam_enroll: exam_enroll,
          current_hub: current_hub,
          expected_hub: expected_hub,
          user: user
        }
      end
    end

    puts "Found #{mismatches.count} hub mismatches"
    puts "-" * 60

    mismatches.each do |mismatch|
      puts "ExamEnroll ID: #{mismatch[:exam_enroll].id}"
      puts "  User: #{mismatch[:user].full_name} (ID: #{mismatch[:user].id})"
      puts "  Current hub: #{mismatch[:current_hub]}"
      puts "  Expected hub (user's main hub): #{mismatch[:expected_hub]}"
      puts ""
    end

    if mismatches.any?
      print "\nDo you want to fix these mismatches? (y/n): "
      response = STDIN.gets.chomp.downcase

      if response == 'y'
        mismatches.each do |mismatch|
          mismatch[:exam_enroll].update!(hub: mismatch[:expected_hub])
          puts "Fixed ExamEnroll ID: #{mismatch[:exam_enroll].id}"
        end
        puts "\nAll mismatches have been fixed!"
      else
        puts "\nNo changes made."
      end
    end
  end
end
