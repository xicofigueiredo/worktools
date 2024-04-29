class Sprint < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, presence: true

  has_many :sprint_goals
  has_many :weeks


  def count_absences(user)
    date_range = start_date..end_date

    Attendance.where(user_id: user.id, attendance_date: date_range)
              .where(absence: 'Unjustified Leave').count
  end

  def count_weekly_goals_total(user)
    date_range = start_date..Date.today

    weekly_goals_count = WeeklyGoal.joins(:week).where(user: user, weeks: { start_date: date_range }).count

    passed_weeks_in_sprint_count = Week.where(start_date: date_range).count

    percent_rate = weekly_goals_count.zero? ? 0 : (weekly_goals_count / passed_weeks_in_sprint_count.to_f * 100).round

    percent_rate
  end

  def count_kdas_total(user)
    date_range = start_date..Date.today

    kdas_count = Kda.joins(:week).where(user: user, weeks: { start_date: date_range }).count

    passed_weeks_in_sprint_count = Week.where(start_date: date_range).count

    percent_rate = kdas_count.zero? ? 0 : (kdas_count / passed_weeks_in_sprint_count.to_f * 100).round

    percent_rate
  end

end
