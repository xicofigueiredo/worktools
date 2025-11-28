class LearnerInfoService

    # Main method to run all daily maintenance tasks
    def self.run_daily_maintenance!
      today = Date.today

      Rails.logger.info "[DailyMaintenance] Starting daily maintenance tasks..."

      # 1. Sync with external services
      sync_hubspot_submissions

      # 2. Update Statuses (Onboarded -> Active, Active -> Inactive)
      sync_learner_statuses!(today)

      # 3. Activate User Accounts (Access preparation)
      activate_upcoming_users!(today)

      # 4. Send Emails
      send_onboarding_emails!(today)
      # send_renewal_reminders!(today)

      Rails.logger.info "[DailyMaintenance] Completed all tasks."
    end

    def self.sync_hubspot_submissions
      Rails.logger.info "[DailyMaintenance] Fetching HubSpot submissions..."
      HubspotService.fetch_new_submissions
    rescue StandardError => e
      Rails.logger.error "[DailyMaintenance] HubSpot Sync Failed: #{e.message}"
    end

    def self.sync_learner_statuses!(today)
      updated_count = 0
      inactivated_learners = []

      candidates = LearnerInfo.where(status: "Onboarded").where("start_date <= ?", today)
                   .or(LearnerInfo.where(status: "Active").where("end_date < ?", today))

      candidates.find_each do |learner|
        previous_status = learner.status
        learner.check_status_updates

        if learner.saved_change_to_status?
          updated_count += 1

          # Track Inactivations for notification
          if learner.status == "Inactive" && previous_status != "Inactive"
            inactivated_learners << learner
          end
        end
      end

      LearnerInfo.check_hub_capacity_and_notify!(inactivated_learners) if inactivated_learners.any?
      Rails.logger.info "[DailyMaintenance] Statuses synced: #{updated_count}. Inactivated: #{inactivated_learners.count}"
    end

    def self.activate_upcoming_users!(today)
      candidates = LearnerInfo.where(status: "Onboarded")
                   .where(start_date: (today + 1.day)..(today + 15.days))
                   .joins(:user)
                   .where(users: { deactivate: true })

      count = 0
      candidates.find_each do |learner|
        learner.user.update(deactivate: false)
        count += 1
      end
      Rails.logger.info "[DailyMaintenance] Users activated: #{count}"
    end

    def self.send_onboarding_emails!(today)
      # Find Onboarded learners starting in next 7 days who haven't received the email
      candidates = LearnerInfo.where(status: "Onboarded", onboarding_email_sent: false)
                   .where(start_date: (today + 1.day)..(today + 7.days))

      count = 0
      candidates.find_each do |learner|
        learner.ensure_worktools_accounts!
        UserMailer.onboarding_email(learner).deliver_now
        learner.update(onboarding_email_sent: true)
        count += 1
      end
      Rails.logger.info "[DailyMaintenance] Onboarding emails sent: #{count}"
    end

    def self.send_renewal_reminders!(today)
      target_month = (today + 1.month).month
      target_day   = today.day

      candidates = LearnerInfo.where(status: "Active").where("extract(day from start_date) = ?", target_day)

      count = 0
      candidates.find_each do |learner|
        if learner.start_date.month == target_month
          UserMailer.renewal_fee_email(learner).deliver_now
          count += 1
        end
      end
      Rails.logger.info "[DailyMaintenance] Renewal emails sent: #{count}"
    end
end
