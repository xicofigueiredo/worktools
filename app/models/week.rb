class Week < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, presence: true

  has_many :weekly_goals
  has_many :kdas
  belongs_to :sprint
  has_many :timeline_progresses

  def week_name_abbr
    if name =~ /\AWeek (\d+)( \/ Build Week)?\z/
      "W#{$1}"
    else
      nil  # or some default value or raise an error, depending on your needs
    end
  end

  def calc_user_average_timeline_progress(user)
    timeline_progresses = self.timeline_progresses.joins(:timeline)
                            .where(timelines: {user_id: user.id})

    if timeline_progresses.any?
      average_progress = timeline_progresses.average(:progress).to_f.round(1)
    else
      average_progress = 0
    end
    average_progress
  end

  def calc_relative_average_timeline_progress(user)
    current_week_average = calc_user_average_timeline_progress(user)
    previous_week = Week.where("start_date < ?", self.start_date).order(:start_date).last

    if previous_week.present?
      previous_week_average = previous_week.calc_user_average_timeline_progress(user)
      relative_average = (current_week_average - previous_week_average).round(1)
    else
      # If there is no previous week, you might return nil or the current week's average as the relative change
      relative_average = current_week_average
    end

    relative_average
  end

  def count_absences(user)
    date_range = start_date..end_date

    Attendance.where(user_id: user.id, attendance_date: date_range)
              .where(absence: 'Unjustified Leave').count
  end

end
