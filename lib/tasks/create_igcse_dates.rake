namespace :exam_dates do
  desc "Create exam dates for subjects containing 'IGCSE' from 2024 to 2028"
  task create_igcse_dates: :environment do
    # Find all subjects containing 'IGCSE' in their name
    igcse = Subject.where("name LIKE ?", "%IGCSE%")
    alevels = Subject.where("name LIKE ?", "%A Level%")

    if igcse.empty?
      puts "No subjects with 'IGCSE' in the name found. Please create the subjects first."
      exit
    end

    if alevels.empty?
      puts "No subjects with 'IGCSE' in the name found. Please create the subjects first."
      exit
    end

    # Define the years and dates
    start_year = 2024
    end_year = 2028
    exam_dates = ["06-03", "11-03"] # June 3 and November 3
    exam_dates_al = ["01-03","06-03", "11-03"] # Jan 3, June 3 and November 3


    # Iterate through each subject and create exam dates
    igcse.each do |subject|
      (start_year..end_year).each do |year|
        exam_dates.each do |date|
          formatted_date = Date.parse("#{year}-#{date}")

          # Check if the ExamDate already exists
          existing_exam_date = ExamDate.find_by(subject_id: subject.id, date: formatted_date)

          if existing_exam_date
            puts "ExamDate already exists for #{formatted_date} (Subject: #{subject.name})"
          else
            # Create a new ExamDate
            ExamDate.create!(
              subject_id: subject.id,
              date: formatted_date
            )
            puts "Created ExamDate: #{formatted_date} (Subject: #{subject.name})"
          end
        end
      end
    end

    alevels.each do |subject|
      (start_year..end_year).each do |year|
        exam_dates_al.each do |date|
          formatted_date = Date.parse("#{year}-#{date}")

          # Check if the ExamDate already exists
          existing_exam_date = ExamDate.find_by(subject_id: subject.id, date: formatted_date)

          if existing_exam_date
            puts "ExamDate already exists for #{formatted_date} (Subject: #{subject.name})"
          else
            # Create a new ExamDate
            ExamDate.create!(
              subject_id: subject.id,
              date: formatted_date
            )
            puts "Created ExamDate: #{formatted_date} (Subject: #{subject.name})"
          end
        end
      end
    end

    puts "Exam dates successfully created or verified for subjects containing 'IGCSE' from #{start_year} to #{end_year}."
  end
end
