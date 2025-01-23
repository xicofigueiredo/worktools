namespace :report_activity do
  desc "Create or update ReportActivity records for Sprint 12"
  task create_or_update_for_sprint_12: :environment do
    # Fetch Sprint 12
    sprint = Sprint.find_by(id: 12)
    if sprint.nil?
      puts "Sprint 12 not found"
      next
    end

    created_count = 0
    updated_count = 0

    # Fetch all sprint goals for Sprint 12
    sprint.sprint_goals.each do |sprint_goal|
      user = sprint_goal.user # Associated user

      # Fetch the user's report for Sprint 12
      report = Report.find_by(user_id: user.id, sprint_id: sprint.id)
      next if report.nil? # Skip if no report exists for the user

      # Process each skill associated with the sprint goal
      sprint_goal.skills.each do |skill|
        activity = skill.extracurricular
        goal = skill.smartgoals
        skill_id = skill.id
        community_id = nil

        next if activity.nil? || goal.nil?

        # Find or initialize the ReportActivity
        report_activity = ReportActivity.find_or_initialize_by(
          report_id: report.id,
          skill_id: skill_id,
        )

        # Update attributes if they differ
        if report_activity.new_record? || report_activity.activity != activity || report_activity.goal != goal
          report_activity.activity = activity
          report_activity.goal = goal
          report_activity.save!
          report_activity.new_record? ? created_count += 1 : updated_count += 1
        end
      end

      # Process each community associated with the sprint goal
      sprint_goal.communities.each do |community|
        activity = community.involved
        goal = community.smartgoals
        skill_id = nil
        community_id = community.id

        next if activity.nil? || goal.nil?

        # Find or initialize the ReportActivity
        report_activity = ReportActivity.find_or_initialize_by(
          report_id: report.id,
          community_id: community_id
        )

        # Update attributes if they differ
        if report_activity.new_record? || report_activity.activity != activity || report_activity.goal != goal
          report_activity.activity = activity
          report_activity.goal = goal
          report_activity.save!
          report_activity.new_record? ? created_count += 1 : updated_count += 1
        end
      end
    end

    puts "#{created_count} ReportActivity records created."
    puts "#{updated_count} ReportActivity records updated."
  end
end
