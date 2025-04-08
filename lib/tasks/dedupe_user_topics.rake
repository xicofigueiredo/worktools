# lib/tasks/dedupe_user_topics.rake
namespace :user_topics do
  desc "Deduplicate UserTopic records by user_id and topic_id"
  task dedupe: :environment do
    puts "Starting UserTopic deduplication..."
    count = 0

    grouped = UserTopic.group(:user_id, :topic_id).having("count(*) > 1").count

    grouped.each_key do |user_id, topic_id|
      duplicates = UserTopic.where(user_id: user_id, topic_id: topic_id).order(:created_at)

      next if duplicates.size <= 1
      
      base = duplicates.last
      to_delete = []

      duplicates[1..].each do |dup|
        if dup.attributes.except("id", "created_at", "updated_at") ==
           base.attributes.except("id", "created_at", "updated_at")
          to_delete << dup
        elsif dup.deadline.nil? && base.deadline.present?
          to_delete << dup
        elsif [nil, false].include?(dup.done) && base.done == true
          to_delete << dup
        end
      end

      if to_delete.any?
        puts "Cleaning #{to_delete.size} duplicates for user_id=#{user_id}, topic_id=#{topic_id}"
        to_delete.each(&:destroy)
      end
      count += to_delete.size
    end

    puts "Deduplication complete. Deleted #{count} duplicate UserTopic records."
  end
end
