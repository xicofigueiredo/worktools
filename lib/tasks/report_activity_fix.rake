namespace :db do
  desc "Backfill skill_id and community_id for report_activities by matching SG's and sprint"
  task report_activity_fix: :environment do
    unmatched_count = 0
    User.where(role: "learner").find_each do |learner|
      report = learner.reports.find_by(sprint: 12)
      sprint_goal = learner.sprint_goals.find_by(sprint: 12)

      # Skip if no report or sprint_goal
      next unless report && sprint_goal

      report.report_activities.find_each do |report_activity|
        # Skip if subject_name is missing
        next unless report_activity.activity.present?
        next unless report_activity.skill_id.nil? || report_activity.community_id.nil?

        # Find activity
        skill = Skill.find_by(extracurricular: report_activity.activity, sprint_goal: sprint_goal)
        community = Community.find_by(involved: report_activity.activity, sprint_goal: sprint_goal)

        # Update only if activity is found
        if skill
          report_activity.update!(skill_id: skill.id)
          puts "Updated report_activity ID: #{report_activity.id} with skill ID: #{skill.id}, sg_id: #{sprint_goal.id}"
        elsif community
          report_activity.update!(community_id: community.id)
          puts "Updated report_activity ID: #{report_activity.id} with community ID: #{community.id}, sg_id: #{sprint_goal.id}"
        else
          unmatched_count += 1
          puts "No matching skill/community found for report_activity ID: #{report_activity.id}, #{unmatched_count}"
        end
      end
    end

    puts "Backfill completed successfully!"
  end
end
