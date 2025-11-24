class AddOnboardingEmailSentToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :onboarding_email_sent, :boolean, default: false
  end
end
