class Community < ApplicationRecord
  belongs_to :sprint_goal
  has_one :report_activity, dependent: :destroy

  after_create :create_report_activity
  CATEGORIES = [
    "Social / Community",
    "Volunteering",
    "Group Projects & Clubs",
    "Networking & Professional Groups",
    "Community Advocacy & Activism"
  ].freeze
  CATEGORY_GROUPS = {
    "Social / Community" => [
      "Volunteering",
      "Group Projects & Clubs",
      "Networking & Professional Groups",
      "Community Advocacy & Activism"
    ]
  }.freeze

  def create_report_activity
    report = Report.find_by(user: self.sprint_goal.user, sprint: self.sprint_goal.sprint)
    ReportActivity.create(report: report, activity: self.involved, goal: self.smartgoals, community_id: self.id)
  end
end
