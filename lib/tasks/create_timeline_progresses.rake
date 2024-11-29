namespace :timeline_progress do
  desc "Create TimelineProgress entries for all Timelines for the current week and save current progress"
  task create_for_current_week: :environment do
    current_week = Week.find_by('start_date <= ? AND end_date >= ?', Date.today, Date.today)

    if current_week.present?
      Timeline.find_each do |timeline|
        # Assuming the Timeline model has a method `current_progress` that returns the latest progress
        current_progress = timeline.progress || 0 # Provide a default if no progress is set
        current_expected = timeline.expected || 0 # Provide a default if no expected progress is set
        current_difference = timeline.difference || 0 # Provide a default if no difference is set

        timeline_progress = timeline.timeline_progresses.find_or_initialize_by(week: current_week)
        timeline_progress.progress = current_progress
        timeline_progress.expected = current_expected
        timeline_progress.difference = current_difference
        timeline_progress.save!

        puts "Updated TimelineProgress for Timeline #{timeline.id} with progress #{current_progress}."
      end
      puts "All TimelineProgress entries for the current week have been created/updated."
    else
      puts "No current week found. Please check the Week configurations."
    end
  end
end
