# lib/tasks/find_learners_without_flags.rake

namespace :users do
  desc "Find learners without LearnerFlag instances and print their IDs"
  task find_learners_without_flags: :environment do
    # Find users with role 'learner' who have no associated LearnerFlag instances
    learners_without_flags = User
                             .joins("LEFT JOIN learner_flags ON learner_flags.user_id = users.id")
                             .where(role: 'learner')
                             .where(learner_flags: { id: nil })

    # Output the IDs of these users
    if learners_without_flags.any?
      puts "IDs of learners without flags:"
      learners_without_flags.each { |user| puts user.id }
    else
      puts "No learners found without flags."
    end
    puts "Total users: #{User.where(role: "learner").count}"
    puts "Total users with flags: #{User.where(role: "learner").joins(:learner_flag).count}"

    if learners_without_flags.any?
      learners_without_flags.each do |user|
        # Create an "empty" LearnerFlag for each user without one
        LearnerFlag.create!(
          user_id: user.id,
          asks_for_help: false,
          takes_notes: false,
          goes_to_live_lessons: false,
          does_p2p: false,
          action_plan: "",
          life_experiences: false
        )
        puts "Created empty LearnerFlag for user ID: #{user.id}"
      end
    else
      puts "No learners found without flags."
    end
  end
end
