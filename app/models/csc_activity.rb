class CscActivity < ApplicationRecord
  belongs_to :csc_diploma
  belongs_to :activitable, polymorphic: true

  has_many_attached :files
  before_save :calculate_rubric_score

  validates :activitable_id, uniqueness: { scope: [:activitable_type, :activity_type] }

  TAG_OPTIONS = [
    'Environment',
    'Leadership',
    'Creativity',
    'Health',
    'Education',
    'Fundraising',
    'Mentoring',
    'Technology',
    'Arts',
    'Sports',
    'Other'
  ].freeze

  STATUS_OPTIONS = [
    ['Needs Revision', 'needs_revision'],
    ['Approved', 'approved'],
    ['Rejected', 'rejected']
  ].freeze

  def approved?
    status == 'approved'
  end

  def needs_revision?
    status == 'needs_revision'
  end

  def rejected?
    status == 'rejected'
  end

  def status_badge_class
    case status
    when 'approved' then 'bg-success'
    when 'rejected' then 'bg-danger'
    else 'bg-warning text-dark'
    end
  end

  def status_display
    case status
    when 'approved' then 'Approved'
    when 'rejected' then 'Rejected'
    else 'Needs Revision'
    end
  end

  def calculate_rubric_score
    return if self.planing.blank? || self.effort.blank? || self.skill.blank? || self.community.blank?
    avg = (self.planing + self.effort + self.skill + self.community).to_f / 4
    if avg >= 3.5
      self.rubric_score = "4 - Exceeds Expectations"
    elsif avg >= 2.5
      self.rubric_score = "3 - Meets Expectations"
    elsif avg >= 1.5
      self.rubric_score = "2 - Approaches Expectations"
    else
      self.rubric_score = "1 - Below Expectations"
    end
  end
end
