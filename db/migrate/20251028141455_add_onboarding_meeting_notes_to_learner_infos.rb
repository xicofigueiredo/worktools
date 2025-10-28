class AddOnboardingMeetingNotesToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :onboarding_meeting_notes, :text
  end
end
