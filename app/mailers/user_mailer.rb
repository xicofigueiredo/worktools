class UserMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Awesome App!')
  end

  # Send password reset instructions
  def reset_password_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  # Send a notification to the userz
  def notification(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'You Have a New Notification')
  end

  def welcome_parent(parent, password, lcs)
    @parent = parent
    @password = password
    mail(to: @parent.email,
         cc: lcs.map(&:email),
         from: 'worktools@bravegenerationacademy.com',
         subject: 'Welcome to the new BGA App!')
  end

  def welcome_cm(cm, password)
    @cm = cm
    @password = password
    mail(to: @cm.email,
         from: 'worktools@bravegenerationacademy.com',
         subject: 'Welcome to the new BGA App!')
  end

  def notifications_summary(user, notifications, lcs_emails)
    @user = user
    @notifications = notifications

    mail(
      to: @user.email,
      cc: lcs_emails,
      from: 'worktools@bravegenerationacademy.com',
      subject: "Notification Summary: You have #{notifications.size} unread notifications"
    )
  end

  def parent_journey_email(parent)
    @parent = parent
    @name = parent.full_name
    @email = parent.email
    @password = parent.encrypted_password

    mail(
      to: @parent.email,
      from: 'worktools@bravegenerationacademy.com',
      subject: "Don't Miss Out – Follow Your Child's Journey on Worktools"
    )
  end
end
