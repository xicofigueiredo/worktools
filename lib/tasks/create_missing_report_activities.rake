namespace :db do
  desc "Ensure all skills and communities for sprint_goal_id=14 have corresponding report_activities"
  task create_missing_report_activities: :environment do
    count = 0

    SprintGoal.where(sprint_id: 14).find_each do |sprint_goal|
      # Get the associated report for the user and sprint
      report = Report.find_by(user_id: sprint_goal.user_id, sprint: 14)

      next unless report # Skip if no report exists for this sprint_goal

      # Process skills for the sprint_goal
      Skill.where(sprint_goal_id: sprint_goal.id).find_each do |skill|
        unless report.report_activities.exists?(skill_id: skill.id)
          report.report_activities.create!(
            activity: skill.extracurricular,
            goal: skill.smartgoals,
            skill_id: skill.id
          )
          count += 1
          puts "Created report_activity for skill ID: #{skill.id} under report ID: #{report.id}"
        end
      end

      # Process communities for the sprint_goal
      Community.where(sprint_goal_id: sprint_goal.id).find_each do |community|
        unless report.report_activities.exists?(community_id: community.id)
          report.report_activities.create!(
            activity: community.involved,
            goal: community.smartgoals,
            community_id: community.id
          )
          count += 1
          puts "Created report_activity for community ID: #{community.id} under report ID: #{report.id}"
        end
      end
    end

    puts "Task completed! Total report_activities created: #{count}"
  end
end
