namespace :exam_dates do
  desc "Create exam dates for subjects containing 'IGCSE' from 2024 to 2028"
  task create_igcse_dates: :environment do
    # Find all subjects containing 'IGCSE' in their name
    subjects = Subject.where("name LIKE ?", "%IGCSE%")

    if subjects.empty?
      puts "No subjects with 'IGCSE' in the name found. Please create the subjects first."
      exit
    end

    # Define the years and dates
    start_year = 2024
    end_year = 2028
    exam_dates = ["06-03", "11-03"] # June 3 and November 3

    # Iterate through each subject and create exam dates
    subjects.each do |subject|
      (start_year..end_year).each do |year|
        exam_dates.each do |date|
          formatted_date = Date.parse("#{year}-#{date}")

          ExamDate.create!(
            subject_id: subject.id,
            date: formatted_date
          )

          puts "Created ExamDate: #{formatted_date} (Subject: #{subject.name})"
        end
      end
    end

    puts "Exam dates successfully created for subjects containing 'IGCSE' from #{start_year} to #{end_year}."
  end
end
