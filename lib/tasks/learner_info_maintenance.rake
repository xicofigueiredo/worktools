namespace :learner_info do
  desc "Run daily maintenance tasks for learner info"
  task daily_maintenance: :environment do
    puts "Running daily maintenance tasks for learner info at #{Time.current}..."
    # begin
    #   LearnerInfoService.run_daily_maintenance!
    #   puts "Daily maintenance completed successfully."
    # rescue StandardError => e
    #   puts "Error running daily maintenance: #{e.message}"
    #   puts e.backtrace.join("\n")
    #   raise
    # end
  end
end
