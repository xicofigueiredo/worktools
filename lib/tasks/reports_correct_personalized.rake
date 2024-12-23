namespace :reports do
  desc "Correct 'personalized' field in ReportKnowledge objects"
  task correct_personalized: :environment do
    puts "Starting to update 'personalized' field..."

    # Fetch all subject names from the Subject table
    subject_names = Subject.pluck(:name)

    # Counter for updated records
    updated_count = 0

    # Iterate through all ReportKnowledge records
    ReportKnowledge.find_each do |report_knowledge|
      # Check if the subject_name is not in the list of subject names
      unless subject_names.include?(report_knowledge.subject_name)
        # Update the personalized field to true
        if report_knowledge.update(personalized: true)
          updated_count += 1
        end
      end
    end

    puts "Completed updating 'personalized' field for ReportKnowledge records."
    puts "Total records updated: #{updated_count}"
  end
end
