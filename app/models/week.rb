class Week < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, presence: true

  has_many :weekly_goals
  has_many :kdas
  belongs_to :sprint

  def week_name_abbr
    if name =~ /\AWeek (\d+)\z/
      "W#{$1}"
    else
      nil  # or some default value or raise an error, depending on your needs
    end
  end

  def count_absences(user)
    date_range = start_date..end_date

    Attendance.where(user_id: user.id, attendance_date: date_range)
              .where(absence: 'Unjustified Leave').count
  end

end
