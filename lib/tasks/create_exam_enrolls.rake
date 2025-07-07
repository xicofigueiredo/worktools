namespace :exam_enrolls do
  desc 'Create exam enrolls for timelines with future exam dates'
  task create: :environment do
    puts "Starting to create exam enrolls for timelines with future exam dates..."

    # Find all timelines that have a future exam date but no exam enroll
    timelines = Timeline.includes(:user, :subject, :exam_date)
                       .where.not(exam_date_id: nil)
                       .where.not(id: ExamEnroll.select(:timeline_id))
                       .joins(:exam_date)
                       .where('exam_dates.date > ?', Date.today)

    puts "Found #{timelines.count} timelines that need exam enrolls"

    timelines.each do |timeline|
      puts "\nProcessing timeline for #{timeline.user.full_name} - #{timeline.subject.name}"

      # Get the user's main hub and available learning coaches
      hub = timeline.user.users_hubs.find_by(main: true)&.hub

      if hub.nil?
        puts "  Skipping: No main hub found for user #{timeline.user.full_name}"
        next
      end

      lcs = hub.users.where(role: 'lc', deactivate: false).reject do |lc|
        lc.hubs.count >= 3
      end

      lc_ids = lcs.present? ? lcs.map(&:id) : []

      # Create the exam enroll
      exam_enroll = ExamEnroll.new(
        timeline_id: timeline.id,
        learner_name: timeline.user.full_name,
        hub: hub.name,
        learning_coach_ids: lc_ids,
        date_of_birth: timeline.user.birthday,
        subject_name: timeline.subject.name,
        learner_id_number: timeline.user.id_number,
        gender: timeline.user.gender,
        native_language_english: timeline.user.native_language_english,
        code: timeline.subject.code,
        exam_board: timeline.subject.board
      )

      if exam_enroll.save
        puts "  Created exam enroll successfully"
      else
        puts "  Failed to create exam enroll: #{exam_enroll.errors.full_messages.join(', ')}"
      end
    end

    puts "\nFinished creating exam enrolls"
  end
end
