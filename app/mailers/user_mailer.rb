class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Awesome App!')
  end

  # Send password reset instructions
  def password_reset(user)
    @user = user
    @token = user.reset_password_token # Assuming you have a method to generate this
    mail(to: @user.email, subject: 'Your Password Reset Instructions')
  end

  # Send a notification to the user
  def notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'You Have a New Notification')
  end
end