class MoodleAssignment < ApplicationRecord
  belongs_to :subject
  has_many :submissions, foreign_key: :moodle_assignment_id, dependent: :destroy

  validates :moodle_id, presence: true, uniqueness: true
  validates :name, presence: true

  # Recalculate and persist average grading time (business days) across graded submissions
  def recalculate_grading_time!
    graded = submissions.where.not(grading_date: nil, submission_date: nil)
    return update!(grading_time: nil) if graded.empty?

    total_days = 0
    count = 0

    graded.find_each do |s|
      total_days += business_days_between(s.submission_date, s.grading_date)
      count += 1
    end

    avg = count > 0 ? (total_days.to_f / count) : nil
    update!(grading_time: avg)
  end

  private

  def business_days_between(start_time, end_time)
    return 0 if start_time.blank? || end_time.blank?
    start_date = start_time.to_date
    end_date = end_time.to_date
    return 0 if end_date < start_date

    count = 0
    (start_date..end_date).each do |d|
      next if d.saturday? || d.sunday?
      count += 1
    end
    count
  end
end
