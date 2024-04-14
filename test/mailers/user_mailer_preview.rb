class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.first)
  end

  def password_reset
    UserMailer.password_reset(User.first)
  end

  def notification
    UserMailer.notification(User.first, "This is a test notification.")
  end
end
