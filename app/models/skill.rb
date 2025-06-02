class Skill < ApplicationRecord
  belongs_to :sprint_goal
  has_one :report_activity, dependent: :destroy

  after_create :create_report_activity
  after_update :update_report_activity

  CATEGORY_GROUPS = {
    "Creative / Arts" => [
      "Visual Arts",
      "Performing Arts",
      "Literary Arts",
      "Digital & Media Arts",
      "Crafts & Maker"
    ],
    "Physical / Fitness" => [
      "Cardio & Endurance",
      "Strength & Conditioning",
      "Flexibility & Balance",
      "Sports & Recreation",
      "Outdoor Adventure"
    ],
    "Academic / Skill-based" => [
      "Languages",
      "Formal Coursework",
      "Professional Development",
      "Technical & Practical Skills"
    ],
    "Personal Well-being" => [
      "Mindfulness & Mental Health",
      "Reading & Intellectual Growth",
      "Self-Care & Habits",
      "Creative Self-Expression"
    ],
    "Other" => [
      "Pets & Animal Care",
      "Home & Garden",
      "Travel & Exploration",
      "Finance & Planning"
    ],
    "Social / Community" => [
      "Volunteering",
      "Group Projects & Clubs",
      "Networking & Professional Groups",
      "Community Advocacy & Activism"
    ]
  }.freeze
  # serialize :categories, Array # (if not using Postgres array)

  def create_report_activity
    report = Report.find_or_create_by(user: self.sprint_goal.user, sprint: self.sprint_goal.sprint)
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
