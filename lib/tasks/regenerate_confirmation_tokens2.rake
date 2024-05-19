namespace :users do
  desc "Regenerate confirmation tokens for all users who haven't been confirmed"
  task regenerate_confirmation_tokens2: :environment do
    User.find_each do |user|
      if user.confirmed_at.nil? && !user.confirmed?
        user.confirmed_at = Time.now.utc
        user.save!
        puts "Generated confirmation time for #{user.email}"
      end
    end
  end
end
