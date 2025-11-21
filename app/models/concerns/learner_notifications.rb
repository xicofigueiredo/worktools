module LearnerNotifications
  extend ActiveSupport::Concern

  # CLASS METHODS
  class_methods do
    def admissions_users
      [User.find_by(email: "contact@bravegenerationacademy.com")].compact
    end

    def finance_users
      [User.find_by(email: "maria.m@bravegenerationacademy.com")].compact
    end

    def curriculum_responsibles(curriculum)
      curr = curriculum.to_s.strip.downcase
      if curr.include?('portuguese')
        User.where(email: ['luis@bravegenerationacademy.com', 'goncalo.meireles@edubga.com'])
      elsif curr.start_with?('up')
        [User.find_by(email: 'esther@bravegenerationacademy.com')].compact
      else
        [User.find_by(email: 'danielle@bravegenerationacademy.com')].compact
      end
    end

    def notify_recipients(recipients, message, link: nil)
      recipients = Array.wrap(recipients)
      return if recipients.blank? || message.blank?

      recipients.each do |user|
        Notification.create!(user: user, message: message, link: link, read: false)
      end
      Rails.logger.info("[Global Notification] Sent to #{recipients.size} users.")
    end
  end

  # INSTANCE METHODS
  def notify_recipients(recipients, message, link: nil)
    recipients = Array.wrap(recipients)
    return if recipients.blank? || message.blank?

    target_learner = self.is_a?(LearnerFinance) ? self.learner_info : self
    return unless target_learner

    link ||= Rails.application.routes.url_helpers.admission_path(target_learner)

    recipients.each do |user|
      Notification.create!(user: user, message: message, link: link, read: false)
    end

    Rails.logger.info("[Notification] Sent to #{recipients.size} users about #{target_learner.full_name}.")
  end
end
