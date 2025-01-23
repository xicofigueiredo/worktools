require 'csv'

namespace :db do
  desc "Check if each learner's ID is contained in the parent.kids array"
  task check_parent_kids: :environment do
    file_path = 'lib/tasks/parents.csv' # Adjust the path to your CSV file

    # Collect learners and parents from the database
    learners = User.where(role: 'learner').index_by(&:email)
    parents = User.where(role: 'Parent').index_by(&:email)

    missing_links = []

    # Process each row in the CSV
    CSV.foreach(file_path, headers: true) do |row|
      learner_email = row['Institutional Email'].strip.downcase
      parent1_email = row['Guardian 1 email']&.strip&.downcase
      parent2_email = row['Guardian 2 email']&.strip&.downcase
      parent3_email = row['Guardian 3 email']&.strip&.downcase

      learner = learners[learner_email]

      if learner.nil?
        puts "Learner with email #{learner_email} does not exist in the database."
        next
      end

      # Check each parent
      [parent1_email, parent2_email, parent3_email].compact.each do |parent_email|
        parent = parents[parent_email]

        if parent.nil?
          puts "Parent with email #{parent_email} does not exist in the database."
          next
        end

        unless parent.kids.include?(learner.id)
          missing_links << { parent_email: parent.email, learner_email: learner.email }
          puts "Learner #{learner.email} is not linked to Parent #{parent.email}."
        end
      end
    end

    # Log missing links
    if missing_links.any?
      puts "\nSummary of missing links:"
      missing_links.each do |link|
        puts "Parent: #{link[:parent_email]} is missing Learner: #{link[:learner_email]}"
      end
    else
      puts "All learners are correctly linked to their parents."
    end
  end
end
