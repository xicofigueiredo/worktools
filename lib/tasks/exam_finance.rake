namespace :exam_finance do
  desc "Create exam finances for all learners based on their exam enrollments"
  task create_for_all: :environment do
    class Helper
      include ExamFinancesHelper
    end
    helper = Helper.new

    puts "Starting to create exam finances for all learners..."

    # Get all exam enrollments grouped by user and exam season
    exam_enrolls = ExamEnroll.joins(:timeline)
                            .joins(timeline: :user)
                            .includes(timeline: [:user, :exam_date])
                            .where.not(timelines: { user_id: nil })
                            .where(timelines: { hidden: false })
                            .where(users: { deactivate: false, role: 'learner' })

    # Group enrollments by user and exam season
    grouped_enrolls = exam_enrolls.group_by do |enroll|
      [enroll.timeline.user_id, enroll.display_exam_date]
    end

    created_count = 0
    existing_count = 0

    grouped_enrolls.each do |group, enrolls|
      user_id, exam_season = group

      # Skip if no valid user or exam season
      next if user_id.nil? || exam_season.nil?

      # Find or create exam finance
      exam_finance = ExamFinance.find_by(user_id: user_id, exam_season: exam_season)

      if exam_finance.nil?
        # Calculate initial total cost
        total_cost = enrolls.sum { |enroll| helper.calculate_total_cost([enroll]) }

        ExamFinance.create!(
          user_id: user_id,
          exam_season: exam_season,
          total_cost: total_cost,
          currency: 'EUR', # Default to EUR
          status: 'No Status'
        )
        created_count += 1
        puts "Created exam finance for User ID: #{user_id}, Season: #{exam_season}"
      else
        existing_count += 1
      end
    end

    puts "\nTask completed!"
    puts "Created #{created_count} new exam finances"
    puts "Found #{existing_count} existing exam finances"
    puts "Total processed: #{created_count + existing_count}"
  end

  desc "Update total costs for all exam finances"
  task update_costs: :environment do
    class Helper
      include ExamFinancesHelper
    end
    helper = Helper.new

    puts "Starting to update costs for all exam finances..."

    updated_count = 0

    ExamFinance.joins(:user)
               .where(users: { deactivate: false, role: 'learner' })
               .find_each do |finance|
      # Get all enrolls for this finance
      enrolls = ExamEnroll.joins(:timeline)
                         .joins(timeline: :user)
                         .where(timelines: { user_id: finance.user_id, hidden: false })
                         .where(users: { deactivate: false, role: 'learner' })
                         .select { |enroll| enroll.display_exam_date == finance.exam_season }

      # Calculate total cost
      total_cost = enrolls.sum { |enroll| helper.calculate_total_cost([enroll]) }

      if finance.total_cost != total_cost
        finance.update!(total_cost: total_cost)
        updated_count += 1
        puts "Updated cost for Exam Finance ID: #{finance.id} (User: #{finance.user_id}, Season: #{finance.exam_season})"
      end
    end

    puts "\nTask completed!"
    puts "Updated costs for #{updated_count} exam finances"
  end
end
