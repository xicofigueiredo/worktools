class ExamDate < ApplicationRecord
  belongs_to :subject, foreign_key: :subject_id
  has_many :timelines

  def formatted_date
    date.strftime("%B %Y") # Formats the date as "Month Year", e.g., "April 2024"
  end
  
  def formatted_name
    if date.month == 5 || date.month == 6
      "May/June #{date.year}"
    elsif date.month == 10 || date.month == 11
      "Oct/Nov #{date.year}"
    else
      date.strftime("%B %Y")
    end
  end


end
