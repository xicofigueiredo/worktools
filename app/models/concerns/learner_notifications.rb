module LearnerNotifications
  extend ActiveSupport::Concern

  included do
    after_update :notify_up_curriculum_responsible_if_changed
    after_update :notify_new_lc_and_manager_if_changed
  end

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

  private

  def notify_up_curriculum_responsible_if_changed
    relevant_fields = ['hub_id', 'grade_year', 'curriculum_course_option']
    relevant_changes = saved_changes.slice(*relevant_fields)
    return if relevant_changes.blank?

    old_curr = saved_changes['curriculum_course_option'] ? saved_changes['curriculum_course_option'][0] : curriculum_course_option
    new_curr = curriculum_course_option

    if old_curr.to_s.strip.downcase.start_with?('up') || new_curr.to_s.strip.downcase.start_with?('up')
      change_details = relevant_changes.map { |k, v| "#{k.gsub('_', ' ').titleize} changed from #{v[0].inspect} to #{v[1].inspect}" }.join(', ')
      message = "UP Learner #{full_name} has updates: #{change_details}."
      notify_recipients(self.class.curriculum_responsibles('up'), message)
    end
  end

  def notify_new_lc_and_manager_if_changed
    # Only run if the update was on LearnerInfo
    return unless self.is_a?(LearnerInfo)

    # Only run if the specific column 'learning_coach_id' changed
    return unless saved_change_to_learning_coach_id?

    # Get the new ID from the changes array [old_val, new_val]
    new_lc_id = saved_change_to_learning_coach_id[1]

    # Return if there is no new coach (e.g. coach was removed/set to nil)
    return unless new_lc_id

    # Fetch Users
    new_lc = User.find_by(id: new_lc_id)
    # TO DO: WHEN THIS FUNCTION CHANGE TO HAVE HUB LOGIC CHANGE HOW WE GET THE RM
    rm = User.find_by(email: "michi@edubga.com")

    # Notify New LC
    if new_lc
      notify_recipients(new_lc, "You have been assigned as the Learning Coach for #{full_name}.")
    end

    # Notify Regional Manager
    if rm && new_lc
      notify_recipients(rm, "Learner #{full_name} has been assigned to Learning Coach #{new_lc.full_name}.")
    end
  end
end
