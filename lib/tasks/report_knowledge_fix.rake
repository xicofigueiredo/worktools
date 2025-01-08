namespace :db do
  desc "Backfill knowledge_id for report_knowledges by matching subject names and sprint"
  task report_knowledge_fix: :environment do
    count = 0
    User.where(role: "learner").find_each do |learner|
      report = learner.reports.find_by(sprint: 12)
      sprint_goal = learner.sprint_goals.find_by(sprint: 12)

      # Skip if no report or sprint_goal
      next unless report && sprint_goal

      report.report_knowledges.find_each do |report_knowledge|
        # Skip if subject_name is missing
        next unless report_knowledge.subject_name.present?
        next unless report_knowledge.knowledge_id.nil?

        # Find knowledge by subject_name and sprint_goal
        knowledge = Knowledge.find_by(subject_name: report_knowledge.subject_name, sprint_goal: sprint_goal)

        # Update only if knowledge is found
        if knowledge
          report_knowledge.update!(knowledge_id: knowledge.id)
          puts "Updated ReportKnowledge ID: #{report_knowledge.id} with Knowledge ID: #{knowledge.id}"
        else
          # report_knowledge.destroy!
          count += 1
          puts "No matching knowledge found for ReportKnowledge ID: #{report_knowledge.id}, #{count}"
        end
      end
    end

    puts "Backfill completed successfully!"
  end
end
