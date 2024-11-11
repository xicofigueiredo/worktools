class Report < ApplicationRecord
  belongs_to :user
  belongs_to :sprint

  validates :user_id, uniqueness: { scope: :sprint_id, message: "Report already exists for this user and sprint" }

  has_many :report_knowledges, dependent: :destroy
  has_many :report_activities, dependent: :destroy

  enum sdl_long_term_plans: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :sdl_long_term_plans
  enum sdl_week_organization: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :sdl_week_organization
  enum sdl_achieve_goals: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :sdl_achieve_goals
  enum sdl_study_techniques: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :sdl_study_techniques
  enum sdl_initiative_office_hours: { rarely: 0, occasionally: 1, consistently: 2 },
       _prefix: :sdl_initiative_office_hours
  enum ini_new_activities: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :ini_new_activities
  enum ini_goal_setting: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :ini_goal_setting
  enum mot_integrity: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :mot_integrity
  enum mot_improvement: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :mot_improvement
  enum p2p_support_from_peers: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :p2p_support_from_peers
  enum p2p_support_to_peers: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :p2p_support_to_peers
  enum hub_cleanliness: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :hub_cleanliness
  enum hub_respectful_behavior: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :hub_respectful_behavior
  enum hub_welcome_others: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :hub_welcome_others
  enum hub_participation: { rarely: 0, occasionally: 1, consistently: 2 }, _prefix: :hub_participation

  accepts_nested_attributes_for :report_knowledges, allow_destroy: true
  accepts_nested_attributes_for :report_activities, allow_destroy: true

  def self.update_daily_knowledge
    active_reports = Report.joins(:sprint).where("sprints.start_date <= ? AND sprints.end_date > ?", Date.today,
                                                 Date.today)

    active_reports.each do |report|
      timelines = report.user.timelines.left_outer_joins(:subject, :exam_date)

      timelines.pluck('subjects.name', :personalized_name, :progress, :difference, 'exam_dates.date').each do |data|
        name = data[1] || data[0]

        # Find or initialize ReportKnowledge record by subject_name
        knowledge_record = report.report_knowledges.find_or_initialize_by(subject_name: name)

        # Update progress and difference as necessary
        knowledge_record.progress = data[2]
        knowledge_record.difference = data[3]

        # Set exam_season only if it hasn’t been set before
        if knowledge_record.exam_season.nil?
          knowledge_record.exam_season = data[4].is_a?(Date) ? data[4].strftime("%B %Y") : data[4]
        end

        # Save each record
        knowledge_record.save
      end

      # Update the last check date
      report.update(last_update_check: Date.today)
    end
  end
end
