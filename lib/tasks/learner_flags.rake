namespace :learner_flags do
  desc "Create LearnerFlag for all users"
  task create_for_all_users: :environment do
    User.where(role: "learner").find_each do |user|
      LearnerFlag.find_or_create_by(user: user)
      puts "Created LearnerFlag for learner ##{user.id}"
      if user.role != "learner" || user.role != "admin"
        user.learner_flag.destroy
        puts "Deleted LearnerFlag for non-learner ##{user.id}"
      end
    end
  end
end
