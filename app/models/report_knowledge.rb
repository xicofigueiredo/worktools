class ReportKnowledge < ApplicationRecord
  belongs_to :report

  validates :subject_name, presence: true
  validates :progress, presence: true
  validates :difference, presence: true

end
