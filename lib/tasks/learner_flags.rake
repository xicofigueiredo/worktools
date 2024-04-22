namespace :learner_flags do
  desc "Create LearnerFlag for all users"
  task create_for_all_users: :environment do
    User.find_each do |user|
      LearnerFlag.find_or_create_by(user: user)
      puts "Created LearnerFlag for user ##{user.id}"
    end
  end
end
