class ApplicationMailer < ActionMailer::Base
  # Email addresses for sending emails
  FROM_WORKTOOLS = 'worktools@bravegenerationacademy.com'
  FROM_CONTACT = 'contact@bravegenerationacademy.com'

  default from: FROM_WORKTOOLS
  layout 'mailer'
end
