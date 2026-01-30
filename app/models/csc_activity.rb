class CscActivity < ApplicationRecord
  belongs_to :csc_diploma
  belongs_to :activitable, polymorphic: true

  has_many_attached :files
  before_save :calculate_rubric_score

  validates :activitable_id, uniqueness: { scope: :activitable_type }

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
