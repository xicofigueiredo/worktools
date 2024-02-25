namespace :user_topics do
  desc "Update percentages for existing UserTopic records"
  task update_percentages: :environment do
    UserTopic.find_each do |user_topic|
      user_topic.update_percentage if user_topic.topic.subject.present?
    end
  end
end
