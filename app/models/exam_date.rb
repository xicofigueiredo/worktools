class ExamDate < ApplicationRecord
  belongs_to :subject, foreign_key: :subject_id
  has_many :timelines

  def formatted_date
    date.strftime("%B %Y") # Formats the date as "Month Year", e.g., "April 2024"
  end
end
