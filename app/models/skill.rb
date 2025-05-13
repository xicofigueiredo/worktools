class Skill < ApplicationRecord
  belongs_to :sprint_goal
  has_one :report_activity, dependent: :destroy

  after_create :create_report_activity
  after_update :update_report_activity

  enum category: { test: 'test', sports: 'sports', music: 'music', art: 'art', other: 'other' }

  def create_report_activity
    report = Report.find_by(user: self.sprint_goal.user, sprint: self.sprint_goal.sprint)
    ReportActivity.create(report: report, activity: self.extracurricular, goal: self.smartgoals, skill_id: self.id)
  end

  def update_report_activity
    return unless report_activity.present?
    report_activity.update(
      activity: self.extracurricular,
      goal: self.smartgoals
    )
  end
end
