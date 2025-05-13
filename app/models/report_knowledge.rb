class ReportKnowledge < ApplicationRecord
  belongs_to :report
  belongs_to :knowledge

  validates :subject_name, presence: true
end
