namespace :users do
  desc "Regenerate and send confirmation and reset password tokens to all users who haven't received them"
  task regenerate_tokens: :environment do
    User.find_each do |user|
      unless user.confirmed? || user.confirmation_sent_at.present?
        begin
          user.confirmation_token = Devise.token_generator.digest(User, :confirmation_token, Devise.friendly_token)
          user.confirmation_sent_at = Time.now.utc
          user.save!
          user.send_confirmation_instructions
          puts "Sent confirmation email to #{user.email}"
        rescue Net::SMTPAuthenticationError => e
          puts "SMTPAuthenticationError for #{user.email}: #{e.message}. Retrying in 60 seconds."
          sleep(60)
          retry
        end
        sleep(10) # Adding a 10-second delay to avoid rate limiting
      end

      if user.reset_password_token.blank? || user.reset_password_sent_at.blank?
        begin
          user.reset_password_token = Devise.token_generator.digest(User, :reset_password_token, Devise.friendly_token)
          user.reset_password_sent_at = Time.now.utc
          user.save!
          user.send_reset_password_instructions
          puts "Sent reset password email to #{user.email}"
        rescue Net::SMTPAuthenticationError => e
          puts "SMTPAuthenticationError for #{user.email}: #{e.message}. Retrying in 60 seconds."
          sleep(60)
          retry
        end
        sleep(10) # Adding a 10-second delay to avoid rate limiting
      end
    end
  end
end
