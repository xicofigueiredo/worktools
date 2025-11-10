class Week < ApplicationRecord
  validates :start_date, :end_date, :name, presence: true

  has_many :weekly_goals
  has_many :kdas
  belongs_to :sprint
  has_many :timeline_progresses
  has_many :consents, dependent: :nullify
  has_many :consent_activities, dependent: :destroy
  has_many :consent_study_hubs, dependent: :destroy

  def week_name_abbr
    if (match = name.match(/\AWeek (\d+)(?: \/ Build Week)?\z/))
      "W#{match[1]}"
    else
      "-"
    end
  end

  def calc_user_average_timeline_progress(user)
    avg = timeline_progresses
            .joins(:timeline)
            .where(timelines: { user_id: user.id })
            .average(:progress)
    (avg || 0).to_f.round(1)
  end

  def calc_relative_average_timeline_progress(user)
    current_avg = calc_user_average_timeline_progress(user)
    previous_week = Week.where("start_date < ?", start_date).order(:start_date).last
    previous_avg = previous_week ? previous_week.calc_user_average_timeline_progress(user) : current_avg
    relative = (current_avg - previous_avg).round(1)
    relative.negative? ? 0 : relative
  end

  def count_absences(user)
    Attendance.where(
      user_id: user.id,
      attendance_date: start_date..end_date,
      absence: 'Unjustified Leave'
    ).count
  end
end
