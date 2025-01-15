namespace :db do
  desc "Check all ReportKnowledges for subjects and update personalized to true if subject doesn't exist"
  task change_reportknowlegde_personalized: :environment do
    # Fetch all ReportKnowledges
    ReportKnowledge.find_each do |report_knowledge|
      subject_name = report_knowledge.subject_name.strip.downcase

      # Check if a Subject exists with the given name
      subject_exists = Subject.where("LOWER(name) = ?", subject_name).exists?

      unless subject_exists
        # Update personalized to true if the subject does not exist
        report_knowledge.update(personalized: true)
        puts "Updated ReportKnowledge ID #{report_knowledge.id}: set personalized to true."
      else
        puts "Subject exists for ReportKnowledge ID #{report_knowledge.id}, no changes made."
      end
    end

    puts "Finished processing all ReportKnowledges."
  end
end
