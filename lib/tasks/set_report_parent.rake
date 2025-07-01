namespace :db do
  desc "Set report.parent to true for learners from a specific hub ID with sprint 13 reports"
  task set_report_parent: :environment do
    updated_count = 0
    skipped_count = 0

    # Find all learners from a specific hub ID through the users_hubs join table
    User.joins(:users_hubs)
        .where(role: "learner", deactivate: false, users_hubs: { hub_id: [196, 195] })
        .distinct
        .find_each do |learner|
      # Find report with sprint 13
      report = learner.reports.find_by(sprint: 13)

      if report && report.parent != true
        # Update the report's parent field to true
        report.update!(parent: true)
        updated_count += 1
        puts "Updated report ID: #{report.id} for learner ID: #{learner.id} (hub: #{learner.users_hubs.where(hub_id: [196, 195]).first.hub_id})"
      else
        if report.nil?
          skipped_count += 1
          puts "No sprint 13 report found for learner ID: #{learner.id} (hub: #{learner.users_hubs.where(hub_id: [196, 195]).first.hub_id})"
        else
          skipped_count += 1
          puts "Report ID: #{report.id} for learner ID: #{learner.id} (hub: #{learner.users_hubs.where(hub_id: [196, 195]).first.hub_id}) is already set to parent: #{report.parent}"
        end
      end
    end

    puts "Task completed! Updated #{updated_count} reports, skipped #{skipped_count} learners without sprint 13 reports."
  end
end
