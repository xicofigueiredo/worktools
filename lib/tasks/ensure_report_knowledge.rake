namespace :db do
  desc "Ensure ReportKnowledge exists for Knowledge entries in Sprint 13"
  task ensure_report_knowledges: :environment do
    created_count = 0
    skipped_count = 0
    subjects = Subject.pluck(:name, :id).to_h


    User.where(role: "learner", deactivate: false).find_each do |learner|
      report = learner.reports.find_by(sprint: 13)
      sprint_goal = learner.sprint_goals.find_by(sprint: 13)

      # Skip if no report or sprint_goal
      next unless report && sprint_goal

      # Find all knowledges associated with the sprint_goal
      sprint_goal.knowledges.each do |knowledge|
        # Check if a corresponding ReportKnowledge already exists
        report_knowledge = report.report_knowledges.find_by(knowledge_id: knowledge.id)

        if report_knowledge
          # Skip if ReportKnowledge already exists
          skipped_count += 1
          # puts "Skipped: ReportKnowledge already exists for Knowledge ID: #{knowledge.id}"
        else
          if subjects.key?(knowledge.subject_name)
            personalized = false
            subject_id = subjects[knowledge.subject_name]
            timeline = learner.timelines.find_by(subject_id: subject_id)
            progress = timeline&.progress || 0
            difference = timeline&.difference || 0
          else
            personalized = true
            progress = nil
            difference = nil
          end
          begin
          # Create a new ReportKnowledge
          report.report_knowledges.find_or_create_by!(
            knowledge_id: knowledge.id,
            subject_name: knowledge.subject_name,
            exam_season: knowledge.exam_season,
            personalized: personalized,
            progress: progress,
            difference: difference
          )

          created_count += 1
          puts "Created ReportKnowledge for Knowledge ID: #{knowledge.id}"
          rescue => e
          puts "Failed to create ReportKnowledge for Knowledge ID: #{knowledge.id}: #{e.message}"
          end
        end
      end
    end

    puts "Task completed successfully!"
    puts "#{created_count} ReportKnowledge records created."
    puts "#{skipped_count} ReportKnowledge records skipped (already existed)."
  end
end
