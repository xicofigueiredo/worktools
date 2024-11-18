class ReportKnowledge < ApplicationRecord
  belongs_to :report

  validates :subject_name, presence: true
  
end
