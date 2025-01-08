class Knowledge < ApplicationRecord
  belongs_to :sprint_goal
  belongs_to :timeline, optional: true
  validates :mock50, :mock100, :exam_season, presence: false

  has_one :report_knowledge, dependent: :destroy

  after_create :create_report_knowledge

  def create_report_knowledge
    report = Report.find_by(user: self.sprint_goal.user, sprint: self.sprint_goal.sprint)
    ReportKnowledge.create(report: report, subject_name: self.subject_name, exam_season: self.exam_season, knowledge_id: self.id)
  end
end
