namespace :db do
  desc "Set report.parent to true for learners from all hubs except specific ones with sprint 13 reports"
  task set_report_parent: :environment do
    updated_count = 0
    skipped_count = 0
    excluded_hub_ids = [166, 194]

    # Find all learners from all hubs except the specified ones through the users_hubs join table
    User.joins(:users_hubs)
        .where(role: "learner", deactivate: false)
        .where.not(users_hubs: { hub_id: excluded_hub_ids })
        .distinct
        .find_each do |learner|
      # Find report with sprint 13
      report = learner.reports.find_by(sprint: 14)

      if report && report.parent != true
        # Update the report's parent field to true
        report.update!(parent: true)
        updated_count += 1
        puts "Updated report ID: #{report.id} for learner ID: #{learner.id} (hub: #{learner.users_hubs.where.not(hub_id: excluded_hub_ids).first.hub_id})"
      else
        if report.nil?
          skipped_count += 1
          puts "No sprint 13 report found for learner ID: #{learner.id} (hub: #{learner.users_hubs.where.not(hub_id: excluded_hub_ids).first.hub_id})"
        else
          skipped_count += 1
          puts "Report ID: #{report.id} for learner ID: #{learner.id} (hub: #{learner.users_hubs.where.not(hub_id: excluded_hub_ids).first.hub_id}) is already set to parent: #{report.parent}"
        end
      end
    end

    puts "Task completed! Updated #{updated_count} reports, skipped #{skipped_count} learners without sprint 13 reports."
  end
end
